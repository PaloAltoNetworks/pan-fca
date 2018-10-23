// If availability zones are provided, use those, otherwise, use all available
locals {
  //aws_zones = ["${length(var.availability_zones) > 0 ? var.availability_zones : data.aws_availability_zones.default.names}"]
  // aws_zones = ["${split(",", length(join(",", var.availability_zones)) > 0 ? join(",", var.availablity_zones) : join(",", data.aws_availability_zones.default.names))}"] 
  aws_zones = ["${var.region}a", "${var.region}b"]
}

provider "aws" {
  region = "${var.region}"
}
// Create VPC Resource
resource "aws_vpc" "palo" {
  cidr_block = "${var.vpc_cidr}"
  tags = {
    "Name" = "${var.vpc_name }"
    "Application" = "${var.stack_name}"
  }
}

// Create VPN Gateway Resource
resource "aws_vpn_gateway" palo_vpn {
  vpc_id = "${aws_vpc.palo.id}"
  tags {
  "Name" = "${ var.vpc_name }" 
  }
}

#################################
#  create Services VPC Subnets  #
#################################
resource "aws_subnet" "untrust_subnet" {
count = "${length(var.untrust_subnets)}"
  vpc_id = "${aws_vpc.palo.id}"
  cidr_block = "${element(var.untrust_subnets, count.index)}"
  availability_zone = "${element(local.aws_zones, count.index)}"
  tags = {
      "Name" = "${var.stack_name}"
  }
}

resource "aws_subnet" "trust_subnet" {
    count = "${length(var.trust_subnets)}"
  vpc_id = "${aws_vpc.palo.id}"
  availability_zone = "${element(local.aws_zones, count.index)}"
    cidr_block = "${element(var.trust_subnets, count.index)}"
    tags = {
        "Name" = "${var.stack_name}"
    }
}

resource "aws_default_route_table" "palo" {
  default_route_table_id = "${aws_vpc.palo.default_route_table_id}"

  tags {
    "Name" = "${join("", list(var.stack_name, "RT"))}"
  }
}

resource "aws_internet_gateway" "palo" {
  vpc_id = "${aws_vpc.palo.id}"

  tags {
    "Name" = "${join("", list(var.stack_name, "IGW"))}"
  }
}

resource "aws_route_table" "untrust_subnet" {
  vpc_id = "${aws_vpc.palo.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.palo.id}"
  }

  tags {
    "Name" = "${join("", list(var.stack_name, "Untrust-RT"))}"
  }
}

resource "aws_route_table" "trust_subnet" {
  vpc_id = "${aws_vpc.palo.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.palo.id}"
  }

  tags {
    "Name" = "${join("", list(var.stack_name, "Untrust-RT"))}"
  }
}

resource "aws_route_table_association" "untrust_subnet" {
  count          = "${length(var.untrust_subnets)}"
  subnet_id      = "${element(aws_subnet.untrust_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.untrust_subnet.id}"
}

resource "aws_route_table_association" "trust_subnet" {
  count          = "${length(var.trust_subnets)}"
  subnet_id      = "${element(aws_subnet.trust_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.trust_subnet.id}"
}

resource "aws_customer_gateway" "palo_gw" {
  count      = "${length(var.customer_asns)}"
  bgp_asn    = "${element(var.customer_asns, count.index)}"
  ip_address = "${element(aws_eip.untrust_elastic_ip.*.public_ip, count.index)}"
  type       = "ipsec.1"

  tags {
    Name = "MainVPC-CGW-${count.index}"
  }
}

##################################################
#### Create Management Network Security Group ####
##################################################
resource "aws_security_group" "sgWideOpen" {
  name        = "sgWideOpen"
  description = "Wide open security group"
  vpc_id      = "${aws_vpc.palo.id}"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    "Name" = "SgWideOpen"
  }
}

##########################################
#### Create an S3 endpoint in the VPC ####
########################################## 
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "${aws_vpc.palo.id}"
  service_name = "com.amazonaws.${var.region}.s3"
}

resource "aws_vpc_endpoint_route_table_association" "rtpalos3" {
  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
  route_table_id  = "${aws_route_table.untrust_subnet.id}"
}

#########################################
#### Create the Elastic IP Addresses ####
#########################################
resource "aws_eip" "untrust_elastic_ip" {
  count      = "${length(local.aws_zones)}"
  vpc        = true
}

resource "aws_eip" "management_elastic_ip" {
  count      = "${length(local.aws_zones)}"
  vpc        = true
}

