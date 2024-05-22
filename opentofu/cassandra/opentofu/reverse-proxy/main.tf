provider "google" {
	credentials = file(var.gcp_credentials_file)
	project = var.gcp_project
	region = var.gcp_region
	zone = "${var.gcp_region}-${var.gcp_zone}"
}

resource "google_compute_instance" "reverse-proxy" {
	boot_disk {
		device_name = "reverse-proxy"
		initialize_params {
			size = 10
			type = "pd-balanced"
			image = "projects/debian-cloud/global/images/debian-12-bookworm-v20240110"
		}
	}

	machine_type = "e2-small"
	name = "reverse-proxy"
	zone = "${var.gcp_region}-${var.gcp_zone}"
	network_interface {
		subnetwork = "projects/${var.gcp_project}/regions/${var.gcp_region}/subnetworks/default"
		access_config {
			network_tier = "PREMIUM"
		}
		queue_count = 0
	}

	metadata = {
		ssh-keys = "user:${file("../../credentials/ssh-keys/key.pub")}"
	}

	scheduling {
		on_host_maintenance = "MIGRATE"
		provisioning_model = "STANDARD"
	}

	tags = ["http-server", "https-server"]

	service_account {
		email = var.gcp_account_email
		scopes = var.gcp_account_scopes
	}

	provisioner "remote-exec" {
		connection {
			host = self.network_interface.0.access_config.0.nat_ip
			user = "user"
			private_key = file("../../credentials/ssh-keys/key")
		}
		inline = ["echo 'Connected!'"]
	}

	provisioner "local-exec" {
		command = "ANSIBLE_CONFIG=../../ansible/ansible.cfg ansible-playbook -i ${self.network_interface.0.access_config.0.nat_ip}, --private-key=../../credentials/ssh-keys/key ../../ansible/reverse-proxy-playbook.yaml"
	}
}
