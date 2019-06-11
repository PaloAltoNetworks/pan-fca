variable "tags" {
  description = "A map of the tags to use for the resources that are deployed"
  type        = "map"

  default = {
    environment = ""
  }
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created"
  type        = "string"
  default     = ""
}

variable "admin_user" {
  description = "User name to use as the admin account on the VMs that will be part of the VM Scale Set"
  type        = "string"
  default     = "fwadmin"
}

variable "admin_password" {
  description = "Default password for admin account"
  type        = "string"
  default     = "Paloalto1234"
}

variable "azurerm_client_id" {
  type    = "string"
  default = ""
}

variable "azurerm_client_secret" {
  type    = "string"
  default = ""
}

variable "azurerm_subscription_id" {
  type    = "string"
  default = ""
}

variable "azurerm_tenant_id" {
  type    = "string"
  default = ""
}

variable "location" {
  description = "examples: (eastus | eastus2 | centralus)"
  type        = "string"
  default     = ""
}

variable "fw_publisher" {
  type    = "string"
  default = "paloaltonetworks"
}

variable "fw_sku" {
  type    = "string"
  default = "byol"
}

variable "fw_series" {
  type    = "string"
  default = "vmseries1"
}

variable "fw_version" {
  type    = "string"
  default = "latest"
}

variable "fw_size" {
  type    = "string"
  default = "Standard_D3_v2"
}

variable "subnet_names" {
  type    = "list"
  default = [""]
}

variable "name_panmgmt_subnet" {
  default = ""
}

variable "name_untrust_subnet" {
  default = "untrust-subnet"
}

variable "name_trust_subnet" {
  default = "trust-subnet"
}

variable "pan_mgmt_allowed" {
  description = "IP Address allowed to access PAN mgmt interface"
  type        = "string"
  default     = ""
}

variable "bootstrap_dir" {
  description = "Bootstrap root directory name, not required."
  type        = "string"
  default     = ""
}

variable "storage_account" {
  description = "Storage account name used to bootstrap VMSS instances"
  type        = "string"
  default     = ""
}

variable "file_share" {
  default = ""
}

variable "scale_set_name" {
  default = ""
}

variable "mgmt_nsg_name" {
  default = ""
}

variable "rg_transit_name" {
  default = ""
}

variable "hostname_prefix" {
  type    = "string"
  default = ""
}

variable "fw_pip_net_profile" {
  type    = "list"
  default = [""]
}

variable "fw_pip_domain_label" {
  type    = "list"
  default = [""]
}

variable "fw_pip_name" {
  type    = "list"
  default = [""]
}

variable "backend_pool_id_trust" {
  type    = "string"
  default = ""
}

variable "backend_pool_id_untrust" {
  type    = "string"
  default = ""
}

variable "subnet_pool_id_untrust" {
  type    = "string"
  default = ""
}

variable "subnet_pool_id_trust" {
  type    = "string"
  default = ""
}

variable "vnet_name" {
  type = "string"
  default = ""
}

variable "domain_name_label" {
  type = "string"
  default = ""
}

variable "public_ip_name" {
  type = "string"
  default = ""
}