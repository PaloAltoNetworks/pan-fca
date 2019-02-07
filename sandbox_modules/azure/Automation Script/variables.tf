variable "azurerm_client_id" {
  type         = "string"
  default     = ""
}

variable "azurerm_client_secret" {
  type         = "string"
  default     = ""
}

variable "azurerm_subscription_id" {
  type         = "string"
  default    = ""
}

variable "azurerm_tenant_id" {
  type         = "string"
  default    = ""
}

variable "azurerm_instances" {
  type    = "string"
  default = "2"
}

variable "azurerm_vm_admin_username" {
  type        = "string"
  default    = ""
}

variable "azurerm_vm_admin_password" {
  type         = "string"
  default     = ""
}

variable "azurerm_network_security_group" {
  type         = "string"
  default     = ""
}

variable "azurerm_public_ip" {
  default     = ""
}

variable "fwpublicIPName" {
  default = "fwPublicIP"
}

variable "transitrg" {
	default = "stern-terraform-Transit"
}

variable "transitvnet" {
  default = "TransitVNet"
}

variable "transitvnetiprange" {
  default = ["10.217.127.0/24"]
}

variable "mgmtsubnet" {
  default = "10.217.127.64/27"
}

variable "untrustsubnet" {
  default = "10.217.127.0/27"
}

variable "trustsubnet" {
  default = "10.217.127.32/27"
}

variable "egresslbsubnet" {
  default = "10.217.127.96/27"
}

variable "spoke1" {
	default = "stern-terraform-PROD"
}


variable "spoke1vnet" {
	default = "PROD_Private-vNet"
}

variable "spoke1vnetiprange" {
  default = ["10.217.0.0/22"]
}

variable "spoke2vnet" {
	default = "PROD_iDMZ-vNet"
}

variable "spoke2vnetiprange" {
  default = ["10.217.4.0/22"]
}

variable "adminUsername" {
  default = "fwadmin"
}

variable "adminPassword" {
  default = "Paloalto123"
}

variable "location" {
  # east us / east us2 / central us
  default = "north europe"
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
  default = "latest"
}

variable "fw_size" {
  default = "Standard_D3_v2"
}
