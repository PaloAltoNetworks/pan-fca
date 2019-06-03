variable "resource_group_name" {
  # description = "The name of the resource group in which the resources will be created"
  # default     = "terraform_compute"
}

variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  default = "north europe"
}

variable "vnet_subnet_id_trust" {
  description = "The subnet id of the virtual network where the virtual machines will reside."
}

variable "lb_backend_pool_trust" {
  description = "The subnet id of the virtual network where the virtual machines will reside."
  type = "list"
  default = []
}

variable "lb_backend_pool_untrust" {
  description = "The subnet id of the virtual network where the virtual machines will reside."
  type = "list"
  default = []
}

variable "appgw_backend_pool" {
  description = "Backendpool for the Application Gateway"
  type = "list"
  default = []
}


variable "vnet_subnet_id_untrust" {
  description = "The subnet id of the virtual network where the virtual machines will reside."
}

variable "vnet_subnet_id_mgmt" {
  description = "The subnet id of the virtual network where the virtual machines will reside."
}


variable "remote_port" {
  description = "Remote tcp port to be used for access to the vms created via the nsg applied to the nics."
  default     = ""
}

variable "storage_account_type" {
  description = "Defines the type of storage account to be created. Valid options are Standard_LRS, Standard_ZRS, Standard_GRS, Standard_RAGRS, Premium_LRS."
  default     = "Premium_LRS"
}

variable "nb_instances" {
  description = "Specify the number of vm instances"
  default     = ""
}

variable "fw_hostname" {
  description = "local name of the VM"
  default     = "FW"
}

variable "vm_os_simple" {
  description = "Specify UbuntuServer, WindowsServer, RHEL, openSUSE-Leap, CentOS, Debian, CoreOS and SLES to get the latest image version of the specified os.  Do not provide this value if a custom value is used for vm_os_publisher, vm_os_offer, and vm_os_sku."
  default     = ""
}

variable "vm_os_id" {
  description = "The resource ID of the image that you want to deploy if you are using a custom image.Note, need to provide is_windows_image = true for windows custom images."
  default     = ""
}

variable "is_windows_image" {
  description = "Boolean flag to notify when the custom image is windows based. Only used in conjunction with vm_os_id"
  default     = "false"
}

variable "vm_os_publisher" {
  description = "The name of the publisher of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  default     = ""
}

variable "vm_os_offer" {
  description = "The name of the offer of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  default     = ""
}

variable "vm_os_sku" {
  description = "The sku of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  default     = ""
}

variable "vm_os_version" {
  description = "The version of the image that you want to deploy."
  default     = "latest"
}

variable "tags" {
  type        = "map"
  description = "A map of the tags to use on the resources that are deployed with this module."

  default = {
    source = "terraform"
  }
}

variable "enable_ip_forwarding" {
    description = "Option between true and false"
    default ="true"
  
}


variable "public_ip_address_allocation" {
  description = "Defines how an IP address is assigned. Options are Static or Dynamic."
  default     = "dynamic"
}

variable "delete_os_disk_on_termination" {
  description = "Delete datadisk when machine is terminated"
  default     = "false"
}

variable "data_sa_type" {
  description = "Data Disk Storage Account type"
  default     = "Standard_LRS"
}

variable "data_disk_size_gb" {
  description = "Storage data disk size size"
  default     = ""
}

variable "data_disk" {
  type        = "string"
  description = "Set to true to add a datadisk."
  default     = "false"
}

variable "boot_diagnostics" {
  description = "(Optional) Enable or Disable boot diagnostics"
  default     = "false"
}

variable "boot_diagnostics_sa_type" {
  description = "(Optional) Storage account type for boot diagnostics"
  default     = "Standard_LRS"
}

variable "adminUsername" {
  default = "fwadmin"
}

variable "adminPassword" {
  default = "Paloalto1234"
}

variable "vm_publisher" {
  default = "paloaltonetworks"
}

variable "fw_sku"{
  default = "byol"
}

variable "vm_series" {
  default = "vmseries1"
}

variable "fw_version" {
  # Latest / 8.1.0 / 8.0.0 / 7.1.1
  default = "latest"
}

variable "fw_size" {
  default = "Standard_D3_v2"
}

variable "fw_lb_type" {
  description = "Public|Private load balance configuration"
  default = ""
}

variable "general_int_name" {
  description = "Generell name for your interfaces"
  default = "PANFW-"
}

variable "lbtype" {
  default = "public"
}

variable "lbnamepooluntrust" {
  default = ""
}

variable "lbnamepooltrust" {
  default = ""
}

variable "av_set_id" {
  default = ""
}

# variable "av_type" {
#   default = "zones"
# }

# variable "az_list" {
#   type = "list"
#   default = ["1","2"]
# }