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

variable "pm_nodes" {
  description = "List of Proxmox nodes"
  type        = list(string)
}

###################################
# ovpn system container variables #
###################################

variable "pm_ct_target_node" {
  description = "Proxmox node to create the resource"
  type        = string
}

variable "pm_ct_ostemplate" {
  description = "Operating system template for LXC"
  type        = string
}

variable "pm_ct_cores" {
  description = "Number of CPU cores"
  type        = string
}

variable "pm_ct_memory_mb" {
  description = "RAM memory in MB"
  type        = string
}

variable "pm_ct_hostname" {
  description = "LXC hostname"
  type        = string
}

variable "pm_ct_password" {
  description = "LXC password for root user"
  type        = string
}

variable "pm_ct_rootfs_size_gb" {
  description = "LXC HDD size"
  type        = string
}

variable "pm_ct_network_name" {
  description = "LXC network interface name"
  type        = string
}

variable "pm_ct_network_bridge" {
  description = "Proxmox bridge name"
  type        = string
}

variable "pm_ct_network_mask" {
  description = "LXC IP address mask"
  type        = string
}

variable "pm_ct_network_subnet" {
  description = "Network subnet for the containers (CIDR format)"
  type        = string
}

variable "pm_ct_network_gw" {
  description = "LXC gateway IP address"
  type        = string
}

variable "pm_ct_master" {
  description = "Master LXC's IP (swarm manager, registry located here...)"
  type        = string
}

variable "pm_ct_master_id" {
  description = "Master LXC's id (swarm manager, registry located here...)"
  type        = string
}

###################################
# ovpn system container variables #
###################################
variable "pm_master_ovpn_client_ip" {
  description = "Master pve node IP for ovpn client"
  type        = string
}


############################
# Proxmox client container #
############################
variable "pm_client_ct_ip" {
  description = "IP of the LXC receiving the client container's IP"
  type        = string
}

variable "pm_client_ct_id" {
  description = "IP of the LXC receiving the client container's ID"
  type        = string
}