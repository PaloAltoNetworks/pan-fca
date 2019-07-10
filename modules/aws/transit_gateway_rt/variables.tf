variable "name"  {
    description = "Name for tagging - Ingested from VPCTransit.yml"
    default = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

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

variable "propagate_transit_gateway_attachment_id" {
  description = "Transit Gateway Attachment IDs to propagate to route table"
  type        = "list"
  default     = [""]
}

variable "associate_transit_gateway_attachment_id" {
  description = "Transit Gateway Attachment IDs to associate to route table"
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

variable "transit_gateway_id" {
  description = "Transit Gateway ID to Associate Route Table"
  type        = "string"
  default     = ""
}

variable "route_table_count" {
  description = "Number of route tables to create"
  type        = "string"
  default     = "1"
}

variable "propagate_count" {
  description = "Number of Route Table to create"
  type        = "string"
  default     = "0"
}

variable "associate_count" {
  description = "Number of Route Table to create"
  type        = "string"
  default     = "0"
}