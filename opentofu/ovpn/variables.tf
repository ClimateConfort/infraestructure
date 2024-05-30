#############################
# Google provider variables #
#############################

variable "gcp_credentials_file" {  
  description = "json file with Google Credentials"
  type        = string
}

variable "gcp_project" {  
  description = "Google project name"  
  type        = string
}

variable "gcp_region" {  
  description = "Google region name where instances will be deployed"  
  type        = string
}

variable "gcp_zone" {  
  description = "Google zone name where instances will be deployed"  
  type        = string
}


##############################
# Proxmox provider variables #
##############################

variable "pm_master_ip" {
  description = "Proxmox master node IP"
  type        = string
}

variable "pm_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "pm_password" {
  description = "Proxmox login password"
  type        = string
}

variable "pm_user" {
  description = "Proxmox login username"
  type        = string
}


###################################
# ovpn compute instance variables #
###################################

variable "gcp_ovpnci_name" {  
  description = "Google instance name to be deployed"  
  type        = string
}

variable "gcp_ovpnci_machine_type" {  
  description = "Google machine type of instances that will be deployed"  
  type        = string
}

variable "gcp_ovpnci_boot_image" {  
  description = "Google boot image name from which instances will be deployed"  
  type        = string
}

variable "gcp_ovpnci_boot_image_size_gb" {  
  description = "Google boot image size from which instances will be deployed"  
  type        = string
}

variable "gcp_ovpnci_boot_image_type" {  
  description = "Google boot image type from which instances will be deployed"  
  type        = string
}

variable "gcp_ovpnci_account_email" {  
  description = "Google account email"
  type        = string
}

variable "gcp_ovpnci_account_scopes" {
  description = "Google account scopes"
  type        = list
}

variable "gcp_ovpnci_ssh_key" {  
  description = "SSH Key"  
  type        = string
}

variable "gcp_ovpnci_ssh_private_key_file" {  
  description = "SSH Key"  
  type        = string
}


###################################
# ovpn system container variables #
###################################

variable "pm_ovpnsc_target_node" {
  description = "Proxmox node to create the resource"
  type        = string
}

variable "pm_ovpnsc_ostemplate" {
  description = "Operating system template for LXC"
  type        = string
}

variable "pm_ovpnsc_cores" {
  description = "Number of CPU cores"
  type        = string
}

variable "pm_ovpnsc_memory_mb" {
  description = "RAM memory in MB"
  type        = string
}

variable "pm_ovpnsc_hostname" {
  description = "LXC hostname"
  type        = string
}

variable "pm_ovpnsc_password" {
  description = "LXC password for root user"
  type        = string
}

variable "pm_ovpnsc_rootfs_size_gb" {
  description = "LXC HDD size"
  type        = string
}

variable "pm_ovpnsc_network_name" {
  description = "LXC network interface name"
  type        = string
}

variable "pm_ovpnsc_network_bridge" {
  description = "Proxmox bridge name"
  type        = string
}

variable "pm_ovpnsc_network_ip" {
  description = "LXC IP address"
  type        = string
}

variable "pm_ovpnsc_network_mask" {
  description = "LXC IP address mask"
  type        = string
}

variable "pm_ovpnsc_network_gw" {
  description = "LXC gateway IP address"
  type        = string
}
