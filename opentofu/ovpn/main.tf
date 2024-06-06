terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc1"
    }
  }
}

provider "google" {
  credentials     = file(var.gcp_credentials_file)  
  project         = var.gcp_project
  region          = var.gcp_region
  zone            = "${var.gcp_region}-${var.gcp_zone}"
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url      = var.pm_api_url
  pm_password     = var.pm_password
  pm_user         = var.pm_user
}

resource "google_compute_instance" "ovpnci" {

  name = var.gcp_ovpnci_name

  zone = "${var.gcp_region}-${var.gcp_zone}"

  machine_type = var.gcp_ovpnci_machine_type

  scheduling {    
    automatic_restart   = true    
    on_host_maintenance = "MIGRATE"    
    preemptible         = false    
    provisioning_model  = "STANDARD"  
  }

  enable_display      = false

  boot_disk {    
    auto_delete = true
    device_name = var.gcp_ovpnci_name
    initialize_params {      
      image = var.gcp_ovpnci_boot_image
      size  = var.gcp_ovpnci_boot_image_size_gb
      type  = var.gcp_ovpnci_boot_image_type
    }    
    mode = "READ_WRITE"  
  }

  service_account {    
    email  = var.gcp_ovpnci_account_email
    scopes = var.gcp_ovpnci_account_scopes
  }  

  can_ip_forward      = true

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/${var.gcp_project}/regions/${var.gcp_region}/subnetworks/default"
  }  

  shielded_instance_config {    
    enable_integrity_monitoring = true
    enable_secure_boot          = false    
    enable_vtpm                 = true
  }

  metadata = {
    ssh-keys = var.gcp_ovpnci_ssh_key
  } 

  metadata_startup_script = <<-SCRIPT
    #!/bin/bash

    # SSH portua definitu
    PORTUA=443 

    # sed erabili defektuzko SSH portua ordezkatzeko
    sed -i "s/#Port 22/Port $PORTUA/" /etc/ssh/sshd_config

    # SSH zerbitzua berrabiarazi
    systemctl restart sshd
  SCRIPT

  deletion_protection = false

  provisioner "local-exec" {
    command = "ansible-playbook ../../ansible/gcp_fw_https_create.yaml"
  }

  provisioner "local-exec" {
    command = "ANSIBLE_CONFIG=../../ansible/ansible_ovpngcp.cfg ansible-playbook -e 'ansible_ssh_private_key_file=../../credentials/ssh-keys/ovpn-gcp' -e 'internalip=${self.network_interface.0.network_ip}' -i ${self.network_interface.0.access_config.0.nat_ip}, ../../ansible/gcp_ovpn_setup.yaml"
  }

}

resource "null_resource" "ovpnci_ip" {

  depends_on = [
    google_compute_instance.ovpnci
  ]

  provisioner "local-exec" {
    command = "echo '${google_compute_instance.ovpnci.network_interface[0].access_config[0].nat_ip}' > output/ovpnci_external_ip.txt"
  }

  provisioner "local-exec" {
    command = "echo '${google_compute_instance.ovpnci.network_interface[0].network_ip}' > output/ovpnci_internal_ip.txt"
  }
}

resource "null_resource" "ovpn_route" {

  depends_on = [
    null_resource.ovpnci_ip
  ]

  provisioner "local-exec" {
    command = "ansible-playbook ../../ansible/gcp_route_create.yaml"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "ansible-playbook ../../ansible/gcp_route_delete.yaml"
  }

}

resource "null_resource" "ovpn_firewall" {

  provisioner "local-exec" {
    when    = destroy
    command = "ansible-playbook ../../ansible/gcp_fw_https_delete.yaml"
  }

}

resource "null_resource" "ovpn" {

  depends_on = [
    null_resource.ovpn_firewall
  ]

  provisioner "local-exec" {
    command = "ANSIBLE_CONFIG=../../ansible/ansible_ovpnpm.cfg ansible-playbook -e 'ovpnciip=${google_compute_instance.ovpnci.network_interface.0.access_config.0.nat_ip}' -e 'ansible_ssh_private_key_file=../../credentials/ssh-keys/lxc2' -i ${var.pm_ovpnsc_network_ip}, ../../ansible/pm_ovpn_setup.yaml"
  }
}

resource "null_resource" "ovpn_restart" {

  depends_on = [
    null_resource.ovpn
  ]

  provisioner "local-exec" {
    command = "ANSIBLE_CONFIG=../../ansible/ansible_ovpnpm.cfg ansible-playbook -e 'ovpnciip=${google_compute_instance.ovpnci.network_interface.0.access_config.0.nat_ip}' -i ../../ansible/ovpn_inventory.yaml ../../ansible/ovpn_restart.yaml"
  }
}