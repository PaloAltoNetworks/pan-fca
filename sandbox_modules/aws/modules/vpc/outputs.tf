// VPC ID

output "vpc_id" {
    description = "ID of VPC Created"
    value = "${element(concat(aws_vpc.palo.*.id, list("")), 0)}"
}

output "vpc_cidr_block" {
    description = "The CIDR BLock of VPC"
    value = "${element(concat(aws_vpc.palo.*.cidr_block, list("")), 0)}"
}

output "default_security_group_id" {
    description = "The ID of the default security group"
    value = "${element(concat(aws_vpc.palo.*.default_security_group_id, list("")), 0)}"
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with.palo VPC"
  value       = "${element(concat(aws_vpc.palo.*.main_route_table_id, list("")), 0)}"
}

output "availability_zones" {
    description = "List of AZs used with this VPC"
    value = ["${var.availability_zones}"]
}