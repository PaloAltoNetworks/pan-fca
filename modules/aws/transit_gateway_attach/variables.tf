variable "attach_subnet_ids" {
  description = "Subnet IDs used for Attachment"
  type = "list"
  default     = [""]
}

variable "tgw_id" {
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

variable "tags" {
  description = ""
  default     = ""
}