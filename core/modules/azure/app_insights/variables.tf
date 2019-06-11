variable "appinsights_name" {
  description = "Application Insights Name"
  type        = "string"
  default     = ""
}

variable "appinsights_type" {
  description = "Application Insights Type"
  type        = "string"
  default     = ""
}

variable "location" {
  description = "Azure Regional Location"
  type        = "string"
  default     = ""
}

variable "resource_group_name" {
  description = "Azure Resource Group Name to use for Application Insights"
  type        = "string"
  default     = ""
}

variable "tags" {
  description = "Tags to apply"
  type = "map"
  default = {}
}