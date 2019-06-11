variable "location" {
  description = "examples: (eastus | eastus2 | centralus)"
  type        = "string"
  default     = ""
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created"
  type        = "string"
  default     = ""
}

variable "vmss_settings_name" {
  description = "The name of the VMSS setting to store"
  type        = "string"
  default     = ""
}

variable "vmss_default_cap" {
  description = "Default Capacity of a VMSS"
  type        = "string"
  default     = 2
}

variable "vmss_min_cap" {
  description = "Minimum Capacity of a VMSS"
  type        = "string"
  default     = 2
}

variable "vmss_max_cap" {
  description = "Maximum Capacity of a VMSS"
  type        = "string"
  default     = ""
}

variable "vmss_id" {
  description = "Id of VMSS to link settings against"
  type        = "string"
  default     = ""
}

variable "email_notify" {
  description = "Email Address to notify of Scale Set changes"
  type        = "string"
  default     = ""
}

variable "scale_out_threshold" {
  description = "Percentage of CPU before scaling out"
  type        = "string"
  default     = ""
}

variable "scale_in_threshold" {
  description = "Percentage of CPU before scaling in"
  type        = "string"
  default     = ""
}

variable "scale_in_metric_name" {
  description = "Metric Name to select for scaling in"
  type        = "string"
  default     = "Percentage CPU"
}

variable "scale_out_metric_name" {
  description = "Metric Name to select for scaling out"
  type        = "string"
  default     = "Percentage CPU"
}

variable "scale_profile_name" {
  description = "Scale Settings Profile Name"
  type = "string"
  default = ""
}