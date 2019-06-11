variable "location" {
  description = "examples: (eastus | eastus2 | centralus)"
  type        = "string"
  default     = ""
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created"
  default     = "terraform_compute"
}

variable "servicebus_sku" {
  description = "Defines which tier to use. Options are basic, standard or premium."
  default     = "standard"
}

variable "servicebus_cap" {
  description = "(Optional) Specifies the capacity. When sku is Premium can be 1, 2 or 4. When sku is Basic or Standard can be 0 only"
  default     = "0"
}

variable "servicebus_tag" {
  description = "Tag Value for Service Bus"
  default = ""
}