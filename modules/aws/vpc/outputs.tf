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

output "vpc_availability_zones" {
    description = "List of AZs used with this VPC"
    value = ["${local.aws_zones}"]
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
##Variables for autoscaling##
/*
output "LambdaSubnetAz1" {
  value = "${aws_subnet.LambdaSubnetAz1.id}"
}

output "LambdaSubnetAz2" {
  value = "${aws_subnet.LambdaSubnetAz2.id}"
}

output "LambdaSubnetAz3" {
  value = "${aws_subnet.LambdaSubnetAz3.id}"
}

output "LambdaSubnetAz4" {
  value = "${aws_subnet.LambdaSubnetAz4.id}"
}

output "NATGWSubnetAz1" {
  value = "${aws_subnet.NATGWSubnetAz1.id}"
}

output "NATGWSubnetAz2" {
  value = "${aws_subnet.NATGWSubnetAz2.id}"
}

output "NATGWSubnetAz3" {
  value = "${aws_subnet.NATGWSubnetAz3.id}"
}

output "MGMTSubnetAz1" {
  value = "${aws_subnet.MGMTSubnetAz1.id}"
}

output "MGMTSubnetAz2" {
  value = "${aws_subnet.MGMTSubnetAz2.id}"
}

output "MGMTSubnetAz3" {
  value = "${aws_subnet.MGMTSubnetAz3.id}"
}

output "UNTRUSTSubnet1" {
  value = "${aws_subnet.UNTRUSTSubnet1.id}"
}

output "UNTRUSTSubnet2" {
  value = "${aws_subnet.UNTRUSTSubnet2.id}"
}

output "UNTRUSTSubnet3" {
  value = "${aws_subnet.UNTRUSTSubnet3.id}"
}

output "TRUSTSubnet1" {
  value = "${aws_subnet.TRUSTSubnet1.id}"
}

output "TRUSTSubnet2" {
  value = "${aws_subnet.TRUSTSubnet2.id}"
}

output "TRUSTSubnet3" {
  value = "${aws_subnet.TRUSTSubnet3.id}"
}

output "VPCCIDR" {
  value = "${var.VPCCIDR}"
}

output "StackName" {
  value = "${var.StackName}"
}

output "PanFwAmiId" {
  value = "${var.PanFwAmiId}"
}

output "VPCID" {
  value = "${aws_vpc.main.id}"
}
*/