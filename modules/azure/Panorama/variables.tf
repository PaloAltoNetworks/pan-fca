variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created"
  default     = "mainrg"
}

variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
}

variable "vnet_subnet_id_mgmt" {
  description = "The subnet id of the virtual network where the virtual machines will reside."
}


variable "pan_hostname" {
  description = "local name of the VM"
  default     = "Panorama"
}

variable "adminUsername" {
  default = "fwadmin"
}

variable "adminPassword" {
  default = "Paloalto123"
}

variable "pan_publisher" {
  default = "paloaltonetworks"
}

variable "pan_sku"{
  default = "byol"
}

variable "pan_series" {
  default = "panorama"
}

variable "pan_version" {
  default = "latest"
}

variable "pan_size" {
  default = "Standard_DS3_v2"
}

variable "generel_int_name" {
  description = "Generell name for your interfaces"
  default = "panorama"
}
