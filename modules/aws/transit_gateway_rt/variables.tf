variable "route_count" {
  description = "Number of Route Table to create"
  type        = "string"
  default     = "0"
}

variable "destination_cidr_block" {
  description = "Destination CIDR Block for route insertion"
  type        = "list"
  default     = [""]
}

variable "transit_gateway_attachment_id" {
  description = "Transit Gateway Attachment ID For VPC"
  type        = "list"
  default     = [""]
}

variable "transit_gateway_route_table_id" {
  description = "Transit Gateway Route Table ID"
  type        = "list"
  default     = [""]
}

variable "assoc_route_existing" {
  description = "Associate with an existing route (true or false)"
  type        = "string"
  default     = false
}

variable "prop_route_existing" {
  description = "Propogate with an existing route (true or false)"
  type        = "string"
  default     = false
}

variable "assoc_route_new" {
  description = "Associate with a new route table"
  type        = "string"
  default     = false
}

variable "prop_route_new" {
  description = "Associate with a new route table"
  type        = "string"
  default     = false
}

variable "route_table_existing" {
  description = "Use Existing Route Table"
  default     = false
}

variable "route_table_new" {
  description = "Create New Route Table"
  default     = false
}

variable "vpc_assoc_route_count" {
  description = "Number of Route Associations"
  type        = "string"
  default     = "0"
}

variable "vpc_prop_route_count" {
  description = "Number of Route Propogations"
  type        = "string"
  default     = "0"
}

variable "tgw_attach_vpc_id" {
  description = "Transit Gateway Attachment ID for VPC"
  default     = ""
}

variable "tgw_rt_id" {
  description = "Transit Gateway Route ID"
  default     = ""
}

variable "tgw_id" {
  description = "Transit Gateway ID to Associate Route Table"
  type        = "string"
  default     = ""
}

variable "tags" {
  description = "AWS Tag for Transit Gateway Route Table"
  default     = ""
}

variable "route_table_count" {
  description = "Number of route tables to create"
  type        = "string"
  default     = "1"
}
