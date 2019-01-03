

variable "resource_group_name" {
 description = "The name of the resource group in which the resources will be created"
 default     = ""
}

variable "scale_set_name" {
	default = ""
}

variable "email_notify" {
  default = ""
}

variable "location" {
  default = "east us2"
}

variable "fw_publisher" {
  default = "paloaltonetworks"
}

variable "fw_sku"{
  default = "byol"
}

variable "fw_series" {
  default = "vmseries1"
}

variable "fw_version" {
  default = "latest"
}

variable "fw_size" {
  default = "Standard_D3_v2"
}

variable "admin_user" {
   description = "User name to use as the admin account on the VMs that will be part of the VM Scale Set"
   default     = "fwadmin"
}

variable "admin_password" {
   description = "Default password for admin account"
   default = "Paloalto1234"
}

variable "bootstrap_dir" {
  default = ""
}

variable "storage_account" {
  default = ""
}

variable "file_share" {
  default = ""
}

variable "vnet_subnet_id_trust" {
  description = "The subnet id of the virtual network where the virtual machines will reside."
}

variable "vnet_subnet_id_untrust" {
  description = "The subnet id of the virtual network where the virtual machines will reside."
}

variable "vnet_subnet_id_mgmt" {
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

variable "host_prefix_name" {
  description = "Hostname of Firewall (Prefix)"
  default = ""
}

variable "tags" {
  description = "A map of the tags to use for the resources that are deployed"
  type        = "map"
  default = {
   environment = " "
 }
}

variable "domain_name_label" {
  description = "Domain Name Label for the Management Interface"
  default = ""
}

variable "public_dns_name" {
  description = "Unique DNS Name provided to the management interface of the VMSS instance"
  default = ""
}

variable "vmss_max_capacity" {
  description = "Max capacity of vmss instances"
  default = 2
}

variable "vmss_min_capacity" {
  description = "Minimum capacity of vmss instances"
  default = 2
}

variable "vmss_def_capacity" {
  description = "Default amount of instances for vmss"
  default = 2
}

variable "scale_auto_setting_name" {
  description = "Name of vm scale set"
  default = ""
}