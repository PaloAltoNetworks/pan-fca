variable "vpc_id"  {
    description = "Name of VPC to be used with tagging"
    default = ""
}

variable "availability_zones" {
    description = "List of Availability zones"
    type = "list"
    default = []
}