terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc1"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url      = var.pm_api_url
  pm_password     = var.pm_password
  pm_user         = var.pm_user
}

resource "null_resource" "pm_ct_template" {
  
  provisioner "local-exec" {
    command = "ANSIBLE_CONFIG=../../ansible/ansible.cfg ansible-playbook -e 'ansible_ssh_private_key_file=../../credentials/ssh-keys/pmpve1' -i ${var.pm_master_ip}, ../../ansible/pm_ct_template.yaml"
  }
}

resource "proxmox_lxc" "ct" {

  count = length(var.pm_nodes)

  depends_on = [
    null_resource.pm_ct_template
  ]

  target_node  = var.pm_nodes[count.index]
  ostemplate   = var.pm_ct_ostemplate
  cores        = var.pm_ct_cores
  memory       = var.pm_ct_memory_mb
  hostname     = "${var.pm_ct_hostname}-${count.index + 1}"
  password     = var.pm_ct_password
  unprivileged = true
  start        = true

  ssh_public_keys = file("${path.module}/../../credentials/ssh-keys/lxc${count.index + 1}.pub")

  rootfs {
    storage = "local-lvm"
    size    = var.pm_ct_rootfs_size_gb
  }

  network {
    name    = var.pm_ct_network_name
    bridge  = var.pm_ct_network_bridge
    ip     = "${cidrhost(var.pm_ct_network_subnet, count.index + 3)}/${var.pm_ct_network_mask}"
    gw      = var.pm_ct_network_gw
  }

  features {
    nesting = true
  }

  provisioner "local-exec" {
    command = "ANSIBLE_CONFIG=../../ansible/ansible.cfg ansible-playbook -e 'ansible_ssh_private_key_file=../../credentials/ssh-keys/lxc${count.index + 1}' -i ${cidrhost(var.pm_ct_network_subnet, count.index + 3)}, ../../ansible/docker_install.yaml"
  }
}

resource "null_resource" "save-ct-id" {

  depends_on = [
    proxmox_lxc.ct
  ]

  provisioner "local-exec" {
    command = "echo '${proxmox_lxc.ct[1].id}' > ../ovpn/output/ovpnsc_id.txt"
  }

}

resource "null_resource" "pm_ct_setup" {

  depends_on = [
    null_resource.save-ct-id
  ]

  provisioner "local-exec" {
    command = "ANSIBLE_CONFIG=../../ansible/ansible.cfg ansible-playbook -e 'vmid=${proxmox_lxc.ct[1].id}' -e 'ansible_ssh_private_key_file=../../credentials/ssh-keys/pmpve2' -i ${var.pm_master_ovpn_client_ip}, ../../ansible/pm_ct_setup.yaml"
  }
}

resource "null_resource" "docker-swarm" {

  depends_on = [
    null_resource.pm_ct_setup
  ]
  
  provisioner "local-exec" {
    command = "ANSIBLE_CONFIG=../../ansible/ansible.cfg ansible-playbook -i ../../ansible/docker_swarm_inventory.yaml ../../ansible/docker_swarm_setup.yaml"
  }
}

resource "null_resource" "docker-registry" {

  depends_on = [
    null_resource.docker-swarm
  ]
  
  provisioner "local-exec" {
    command = "ANSIBLE_CONFIG=../../ansible/ansible.cfg ansible-playbook -i ../../ansible/docker_swarm_inventory.yaml ../../ansible/docker_registry_setup.yaml"
  }
}

resource "null_resource" "docker-build-push" {

  depends_on = [
    null_resource.docker-registry
  ]
  
  provisioner "local-exec" {
    command = "ANSIBLE_CONFIG=../../ansible/ansible.cfg ansible-playbook -e 'ansible_ssh_private_key_file=../../credentials/ssh-keys/lxc${var.pm_ct_master_id}' -i ${var.pm_ct_master}, ../../ansible/docker_build_push_images.yaml"
  }
}


resource "null_resource" "kafka-cluster" {

  depends_on = [
    null_resource.docker-build-push
  ]
  
  provisioner "local-exec" {
    command = "ANSIBLE_CONFIG=../../ansible/ansible.cfg ansible-playbook -i ../../ansible/kafka_cluster_inventory.yaml ../../ansible/kafka_cluster_deploy.yaml"
  }
}


resource "null_resource" "hadoop-cluster" {

  depends_on = [
    null_resource.kafka-cluster
  ]
  
  provisioner "local-exec" {
    command = "ANSIBLE_CONFIG=../../ansible/ansible.cfg ansible-playbook -i ../../ansible/hadoop_cluster_inventory.yaml ../../ansible/hadoop_cluster_deploy.yaml"
  }
}