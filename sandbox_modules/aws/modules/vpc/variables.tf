variable "vpc_name"  {
    description = "Name of VPC to be used with tagging"
    default = ""
}

variable "stack_name" {
    description = "Application Stack to be deployed"
    default = ""
}

variable "vpc_cidr" {
    description = "Main VPC to be created"
    default = ""
}

variable "untrust_subnets" {
    description = "List of untrusted subnets to create"
    default = []
}

variable "trust_subnets" {
    description = "List of Trusted Subnets to Create"
    default = []
}

variable "availability_zones" {
    description = "List of Availability zones"
    default = []
}

variable "customer_asns" {
    description = "List of ASNs Customer has provided"
    default = []
}

variable "aws_region" {
    description = "AWS region"
    default = "us-east-1"
}

variable "count" {
    description = "count variable"
    default = ""
}
