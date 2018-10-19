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

output "untrust_subnets" {
  description = "List of IDs of untrust subnets"
  value       = ["${aws_subnet.untrust_subnet.*.id}"]
}
output "trust_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${aws_subnet.trust_subnet.*.id}"]
}

output "untrust_subnets_cidr_blocks" {
  description = "List of cidr_blocks of untrusted subnets"
  value       = ["${aws_subnet.untrust_subnet.*.cidr_block}"]
}

output "trust_subnets_cidr_blocks" {
  description = "List of cidr_blocks of trusted subnets"
  value       = ["${aws_subnet.trust_subnet.*.cidr_block}"]
}

output "untrust_route_table_ids" {
    description = "List of untrusted route table ids"
    value = ["${aws_route_table.untrust_subnet.*.id}"]
}

output "untrust_elastic_ip" {
    description = "Create EIP Addresses"
    value = ["${aws_eip.untrust_elastic_ip.*.id}"]
}

output "management_elastic_ip" {
    description = "List of untrusted route table ids"
    value = ["${aws_eip.management_elastic_ip.*.id}"]
}

output "availability_zones" {
    description = "List of untrusted route table ids"
    value = ["${length(var.availability_zones)}"]
}

output "aws_region" {
    description = "Specified Region"
    value = "${var.aws_region}"
}