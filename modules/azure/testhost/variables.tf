variable "resource_group_name" {
  default = "mainrg"
}

variable "hostname" {
  description = "VM name referenced also in storage-related names."
}

variable "dns_name" {
  description = " Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
}

variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
}

variable "storage_account_tier" {
  description = "Defines the Tier of storage account to be created. Valid options are Standard and Premium."
  default     = "Standard"
}

variable "storage_replication_type" {
  description = "Defines the Replication Type to use for this storage account. Valid options include LRS, GRS etc."
  default     = "LRS"
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Basic_A1"
}

variable "image_publisher" {
  description = "name of the publisher of the image (az vm image list)"
  default     = "tunnelbiz"
}

variable "image_offer" {
  description = "the name of the offer (az vm image list)"
  default     = "ubuntu_server"
}

variable "image_sku" {
  description = "image sku to apply (az vm image list)"
  default     = "ubuntu1810webserver"
}

variable "image_version" {
  description = "version of the image to apply (az vm image list)"
  default     = "0.0.1"
}

variable "admin_username" {
  description = "administrator user name"
  default     = "creator"
}

variable "admin_password" {
  description = "administrator password (recommended to disable password auth)"
}

variable "vnet_subnet_id_vm" {
  description = "The subnet id of the virtual network where the virtual machines will reside."
}

variable "tags" {
  type        = "map"
  description = "A map of the tags to use on the resources that are deployed with this module."

  default = {
    source = "terraform"
  }
}