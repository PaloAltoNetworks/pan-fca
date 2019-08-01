variable "name" {
  description = "Service Object Name"
  type = "string"
}

variable "tags" {
  description = "Service Object Tags"
  type = "list"
  default = [""]
}

variable "device_group" {
  description = "Panorama Device Group Specified"
  type = "string"
  default = "shared"
}

variable "services" {
  description = "List of service objects"
  type = "list"
  default = [""]
}