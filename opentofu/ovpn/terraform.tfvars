#############################
# Google provider variables #
#############################
gcp_credentials_file                 = "../../credentials/gcp/pbl6-422712-4d2d1628f0a5.json"
gcp_project                          = "pbl6-422712"
gcp_region                           = "us-west1"
gcp_zone                             = "c"

#######################################
# Proxmox connection related variable #
#######################################
pm_master_ip = "10.0.2.16"
pm_api_url  = "https://10.0.2.16:8006/api2/json"
pm_password = "rootroot"
pm_user     = "root@pam"

###################################
# ovpn compute instance variables #
###################################
gcp_ovpnci_name                    = "ovpnserver"
gcp_ovpnci_machine_type            = "e2-small"
gcp_ovpnci_boot_image              = "projects/debian-cloud/global/images/debian-12-bookworm-v20240110"
gcp_ovpnci_boot_image_size_gb      = 10
gcp_ovpnci_boot_image_type         = "pd-balanced"
gcp_ovpnci_account_email           = "opentofu@pbl6-422712.iam.gserviceaccount.com"
gcp_ovpnci_account_scopes          = [ "https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append" ]
gcp_ovpnci_ssh_key                 = "user:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQClRTtGJBMxgj9xISXsjdjRgPBddchc1gzGDc4C4nIAwtzNNH4IODk/IhYhsmDsb/gH10IaI7iMCjR1brSY8N5KppSBXjGojn8v7mjyH1o3Pvm3Zs3jP0fdEuP5QfvQaXmWQGMjNj58U3TTAHC/lsQ0/SfyqB6RZJAoyTRPy29KhSuAtIBJnivu3HrKGomNC0RBMKUZk4x5kM5k7MJE3ia5cT7CajGd0akP83y9vDEdt4CYhDEHtoiAUKcY9dMJhKJjnbarWswg3JJc2RsUcRH67QAuW0RJmiX7B0b3R/zbIOhQBum3tf0SUBmJoF6wiUb2C6JYwgEdUTdzq+rTcDBWaoRbMJB7XMSn7FRTJLXFMf8WQIzLUw1Yd2NM9aod8QMuXWORndekJajHcIL8+VvqMfUmjL9vZYqjPlwkNUCAMBvaPxJb1koWNX3BvkqARZCzA+lCDto24PV2pfCLHHYsfWA7YceLtN/0wYsbUCmhY5BW+YZAz3XjPgMtr5bCvkOiqUStdEexITnPVPFBdjwKiDQM2Xv0rltKtMhAlF888b/+oT9Gac8B3hlStteu1fTEnQ/6JatAgsqQMr+xU11XbpbRBgKMVRLbk95qdq8ltd0XceRALBjIsUkIxhvZo6DJyIrKOqRD4REa+Z/NPm2JsfqX1OVEA0n+hJTfCnu93Q== user"
gcp_ovpnci_ssh_private_key_file    = "ovpn-gcp"

###################################
# ovpn system container variables #
###################################
pm_ovpnsc_target_node    = "pve1"
pm_ovpnsc_ostemplate     = "local:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst"
pm_ovpnsc_cores          = "1"
pm_ovpnsc_memory_mb      = "1024"
pm_ovpnsc_hostname       = "ovpnclient"
pm_ovpnsc_password       = "rootroot"
pm_ovpnsc_rootfs_size_gb = "8G"
pm_ovpnsc_network_name   = "eth0"
pm_ovpnsc_network_bridge = "vmbr0"
pm_ovpnsc_network_ip     = "10.0.2.8"
pm_ovpnsc_network_mask   = "24"
pm_ovpnsc_network_gw     = "10.0.2.2"
