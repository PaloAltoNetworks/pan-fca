variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "attach_subnet_ids" {
  description = "Subnet IDs used for Attachment"
  default     = []
}

variable "transit_gateway_id" {
  description = "TGW ID"
  default     = ""
}

variable "vpc_id" {
  description = "Spoke VPC ID"
  default     = ""
}

variable "transit_gateway_default_route_table_association" {
  description = ""
  default     = false
}

variable "transit_gateway_default_route_table_propagation" {
  description = "TGW Default RT Propagation"
  default     = false
}
