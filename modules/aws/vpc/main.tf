terraform {
  required_version = ">= 0.10.3"
}

######
# VPC
######
resource "aws_vpc" "this" {
  count = "${var.create_vpc ? 1 : 0}"

  cidr_block                       = "${var.cidr}"
  instance_tenancy                 = "${var.instance_tenancy}"
  enable_dns_hostnames             = "${var.enable_dns_hostnames}"
  enable_dns_support               = "${var.enable_dns_support}"
  assign_generated_ipv6_cidr_block = "${var.assign_generated_ipv6_cidr_block}"
  tags {
  "Name"                           = "${ var.name }" 
  }
  #tags = "${merge(map("Name", format("%s", var.name)), var.tags, var.vpc_tags)}"
}


resource "aws_vpc_ipv4_cidr_block_association" "this" {
  count = "${var.create_vpc && length(var.secondary_cidr_blocks) > 0 ? length(var.secondary_cidr_blocks) : 0}"
  vpc_id = "${aws_vpc.this.id}"
  cidr_block = "${element(var.secondary_cidr_blocks, count.index)}"
}