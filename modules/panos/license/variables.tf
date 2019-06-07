variable "delicense" {
  description = "true or false to remove license"
  default     = false
}

variable "auth_codes" {
  description = "pan list of auth codes"
  type        = "list"
  default     = [""]
}

variable "mode" {
  description = "Only Auto is supported today, but manual in future"
  type        = "string"
  default     = "auto"
}
