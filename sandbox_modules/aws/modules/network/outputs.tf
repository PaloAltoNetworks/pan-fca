output "untrust_subnets" {
  description = "List of IDs of private subnets"
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

output "availability_zones" {
    description = "List of AZs used with this VPC"
    value = ["${var.availability_zones}"]
}

output "untrust_security_group" {
  description = "Security group to use w/untrust subnets"
  value = "${aws_security_group.sgWideOpen.id}"
}

output "trust_security_group" {
  description = "security group to use with trust subnets"
  value = "${aws_security_group.sgWideOpen.id}"
}

output "mgmt_security_group" {
  description = "SG to use w/mgmt subnets"
  value = "${aws_security_group.sgWideOpen.id}"
}

output "untrust_elastic_ips" {
  description = "list of untrusted EIP IDs created"
  value = ["${aws_eip.untrust_elastic_ip.*.id}"]
}

output "untrust_elastic_ip_addresses" {
  description = "list of untrusted EIPs Addresses"
  value = ["${aws_eip.untrust_elastic_ip.*.public_ip}"]
}

output "management_elastic_ips" {
  description = "list of mgmt EIPs created"
  value = ["${aws_eip.management_elastic_ip.*.id}"]
}

output "management_elastic_ip_addresses" {
  description = "list of mgmt EIP Addresses"
  value = ["${aws_eip.management_elastic_ip.*.public_ip}"]
}
