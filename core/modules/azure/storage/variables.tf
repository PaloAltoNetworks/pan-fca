variable "storage_account_name" {
  description = "Palo Alto Networks Storage Account Name for Bootstrap Support"
  type        = "string"
  default     = ""
}

variable "resource_group_name" {
  description = "Palo Alto Networks Resource Group Name"
  type        = "string"
  default     = ""
}

variable "location" {
  description = "Regional Azure Location Name"
  type        = "string"
  default     = ""
}

variable "file_share" {
  description = "Palo Alto Networks Bootstrap File Share Name"
  type        = "list"
  default     = [""]
}

variable "storage_directory" {
  description = "Palo Alto Networks File Share List of Directory Names"
  type        = "list"
  default     = [""]
}

variable "account_tier" {
  description = "Storage Account"
  default     = "Standard"
}

variable "account_replication_type" {
  description = "SA Replication Type"
  default     = "GRS"
}

variable "file_names" {
  description = "List of File Names to upload"
  type        = "list"
  default     = [""]
}

variable "share_type" {
  description = "Type of share (public|private)"
  type        = "list"
  default     = [""]
}
