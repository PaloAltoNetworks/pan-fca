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


variable "customer_asns" {
    description = "List of ASNs Customer has provided"
    type = "list"
    default = []
}

variable "region" {
    description = "AWS region"
    default = "us-east-1"
}


data "aws_availability_zones" "default" {
}