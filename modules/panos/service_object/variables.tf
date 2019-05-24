variable "name" {
  description = "Service Object Name"
  type = "string"
}

variable "protocol" {
  description = "Service Object Protocol"
  type = "string"
}

variable "description" {
  description = "Service Object Description"
  type = "string"
  default = ""
}

variable "source_port" {
  description = "Service Object source port"
  type = "string"
  default = ""
}

variable "destination_port" {
  description = "Service Object destination port"
  type = "string"
}

variable "tags" {
  description = "Service Object Tags"
  type = "list"
  default = [""]
}

variable "object_type" {
  description = "Service object type"
  type = "string"
  default = "panorama"
}

variable "device_group" {
  description = "Panorama Device Group Specified"
  type = "string"
  default = "shared"
}