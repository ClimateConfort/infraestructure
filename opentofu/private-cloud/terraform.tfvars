#######################################
# Proxmox connection related variable #
#######################################
pm_master_ip = "10.0.2.16"
pm_api_url  = "https://10.0.2.16:8006/api2/json"
pm_password = "rootroot"
pm_user     = "root@pam"
pm_nodes    = ["pve1", "pve2", "pve3"]

##################################
# pm system containers variables #
##################################
pm_ct_target_node    = "pve1"
pm_ct_ostemplate     = "local:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst"
pm_ct_cores          = "1"
pm_ct_memory_mb      = "3072"
pm_ct_hostname       = "lxc"
pm_ct_password       = "rootroot"
pm_ct_rootfs_size_gb = "8G"
pm_ct_network_name   = "eth0"
pm_ct_network_bridge = "vmbr0"
pm_ct_network_mask   = "24"
pm_ct_network_subnet = "10.0.2.0/24"
pm_ct_network_gw     = "10.0.2.2"
pm_ct_master         = "10.0.2.3"
pm_ct_master_id      = "1"
