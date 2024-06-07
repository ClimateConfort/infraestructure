provider "google" {
  credentials = file(var.gcp_credentials_file)
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = "${var.gcp_region}-${var.gcp_zone}"
}

# List of instance names
locals {
  instance_names = ["node1", "node2", "node3"]
  
}

resource "google_compute_instance" "node" {
  for_each = toset(local.instance_names)

  boot_disk {
    device_name = "node"
    initialize_params {
      size  = 10
      type  = "pd-balanced"
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20240110"
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    echo 'user ALL=(ALL:ALL) ALL' | sudo tee -a /etc/sudoers.d/ansible
  EOF

  machine_type = "e2-medium"
  name         = each.key
  zone         = "${var.gcp_region}-${var.gcp_zone}"

  network_interface {
    subnetwork = "projects/${var.gcp_project}/regions/${var.gcp_region}/subnetworks/default"
    access_config {
      network_tier = "PREMIUM"
    }
  }

  metadata = {
    ssh-keys = "user:${file("../../credentials/ssh-keys/key.pub")}"
  }

  scheduling {
    on_host_maintenance = "MIGRATE"
    provisioning_model  = "STANDARD"
  }

  tags = ["http-server", "https-server", "cluster"]

  service_account {
    email  = var.gcp_account_email
    scopes = var.gcp_account_scopes
  }

  provisioner "remote-exec" {
    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      user        = "user"
      private_key = file("../../credentials/ssh-keys/key")
    }
    inline = ["echo 'Connected!'"]
  }

  provisioner "local-exec" {
    command = <<-EOT
      ANSIBLE_CONFIG=../../ansible/ansible.cfg ansible-playbook -i ${self.network_interface.0.access_config.0.nat_ip}, --private-key=../../credentials/ssh-keys/key ../../ansible/zabbix-playbook.yaml &
      ANSIBLE_CONFIG=../../ansible/ansible.cfg ansible-playbook -i ${self.network_interface.0.access_config.0.nat_ip}, --private-key=../../credentials/ssh-keys/key ../../ansible/cassandra-start-playbook.yaml &&
      ANSIBLE_CONFIG=../../ansible/ansible.cfg ansible-playbook -i ${self.network_interface.0.access_config.0.nat_ip}, --private-key=../../credentials/ssh-keys/key ../../ansible/nifi-start-playbook.yaml
    EOT
  }

}

resource "google_compute_firewall" "node-ports" {
  name    = "node-ports"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["7000", "7001", "7199", "9042", "9160", "8443", "8080", "10000", "6342", "2181", "2281", "2881", "3881", "4881", "9999", "8088"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["cluster"]
}
