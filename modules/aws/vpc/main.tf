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

##########################################
### Creating VPC resources needed for ####
### Autoscaling Firewall Loadbalancer ####
### Load Balancer Sandwich this will  ####
### Be interchangable with different LB's#
##########################################
/*
  Create the Lambda subnet for the first AZ
*/
/*
resource "aws_subnet" "LambdaSubnetAz1" {
  count = "${var.NATGateway}"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.LambdaSubnetIpBlocks[0]}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = true
  tags {
        "Application" = "AWS::StackId"
        "Network"= "LambdaFunction"
        "Name" = "${join("", list(var.StackName, "LambdaSubnetAz1"))}"
  }
}

/*
  Create the lambda subnet for the second AZ
*/
resource "aws_subnet" "LambdaSubnetAz2" {
  count = "${var.NATGateway}"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.LambdaSubnetIpBlocks[1]}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = true
  tags {
        "Application" = "${var.StackName}"
        "Network"= "LambdaFunction"
        "Name" = "${join("-", list(var.StackName, "LambdaSubnetAz2"))}"
  }
}

/*
  Create the lambda subnet for the third AZ
*/
resource "aws_subnet" "LambdaSubnetAz3" {
  count = "${var.NATGateway * var.NumberOfAzs == 3 ? 1 : 0}"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.LambdaSubnetIpBlocks[2]}"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"
  map_public_ip_on_launch = true
  tags {
        "Application" = "AWS::StackId"
        "Network"= "LambdaFunction"
        "Name" = "${join("-", list(var.StackName, "LambdaSubnetAz3"))}"
  }
}

resource "aws_subnet" "LambdaSubnetAz4" {
  count = "${var.NATGateway * var.NumberOfAzs == 4 ? 1 : 0}"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.LambdaSubnetIpBlocks[3]}"
  availability_zone = "${data.aws_availability_zones.available.names[3]}"
  map_public_ip_on_launch = true
  tags {
        "Application" = "AWS::StackId"
        "Network"= "LambdaFunction"
        "Name" = "${join("-", list(var.StackName, "LambdaSubnetAz4"))}"
  }
}

resource "aws_route_table" "LambdaRouteTableAz1" {
  count = "${var.NATGateway}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "LambdaRouteTableAz2"))}"
  }
}

resource "aws_route_table" "LambdaRouteTableAz2" {
  count = "${var.NATGateway}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "LambdaRouteTableAz2"))}"
  }
}

resource "aws_route_table" "LambdaRouteTableAz3" {
  count = "${var.NATGateway * var.NumberOfAzs == 3 ? 1 : 0}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "LambdaRouteTableAz3"))}"
  }
}

resource "aws_route_table" "LambdaRouteTableAz4" {
  count = "${var.NATGateway * var.NumberOfAzs == 4 ? 1 : 0}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", var.StackName, "LambdaRouteTableAz4")}"
  }
}

resource "aws_subnet" "NATGWSubnetAz1" {
  count = "${var.NATGateway}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  cidr_block = "${var.NATGWSubnetIpBlocks[0]}"
  map_public_ip_on_launch = true
  vpc_id = "${aws_vpc.main.id}"

  tags {
        "Application" = "${var.StackName}"
        "Network"= "LambdaFunction"
        "Name" = "${join("-", list(var.StackName, "NATGWSubnetAz1"))}"
  }
}

resource "aws_subnet" "NATGWSubnetAz2" {
  count = "${var.NATGateway}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  cidr_block = "${var.NATGWSubnetIpBlocks[1]}"
  map_public_ip_on_launch = true
  vpc_id = "${aws_vpc.main.id}"

  tags {
        "Application" = "${var.StackName}"
        "Network"= "LambdaFunction"
        "Name" = "${join("-", list(var.StackName, "NATGWSubnetAz2"))}"
  }
}

resource "aws_subnet" "NATGWSubnetAz3" {
  count = "${var.NumberOfAzs * var.NATGateway == 3 ? 1 : 0}"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"
  cidr_block = "${var.NATGWSubnetIpBlocks[2]}"
  map_public_ip_on_launch = true
  vpc_id = "${aws_vpc.main.id}"

  tags {
        "Application" = "${var.StackName}"
        "Network"= "LambdaFunction"
        "Name" = "${join("-", list(var.StackName, "NATGWSubnetAz3"))}"
  }
}


resource "aws_subnet" "NATGWSubnetAz4" {
  count = "${var.NumberOfAzs * var.NATGateway == 4 ? 1 : 0}"
  availability_zone = "${data.aws_availability_zones.available.names[3]}"
  cidr_block = "${var.NATGWSubnetIpBlocks[3]}"
  map_public_ip_on_launch = true
  vpc_id = "${aws_vpc.main.id}"

  tags {
        "Application" = "${var.StackName}"
        "Network"= "LambdaFunction"
        "Name" = "${join("-", list(var.StackName, "NATGWSubnetAz4"))}"
  }
}

resource "aws_eip" "EIP1" {
  count = "${var.NATGateway}"
  vpc   = true
  depends_on = ["aws_vpc.main", "aws_internet_gateway.InternetGateway"]
}

resource "aws_eip" "EIP2" {
  count = "${var.NATGateway}"
  vpc   = true
  depends_on = ["aws_vpc.main", "aws_internet_gateway.InternetGateway"]
}

resource "aws_eip" "EIP3" {
  count = "${var.NumberOfAzs * var.NATGateway == 3 ? 1 : 0}"
  vpc   = true
  depends_on = ["aws_vpc.main", "aws_internet_gateway.InternetGateway"]
}

resource "aws_eip" "EIP4" {
  count = "${var.NumberOfAzs * var.NATGateway == 4 ? 1 : 0}"
  vpc   = true
  depends_on = ["aws_vpc.main", "aws_internet_gateway.InternetGateway"]
}

resource "aws_nat_gateway" "NAT1" {
  count = "${var.NATGateway == 1 ? 1 : 0}"
  allocation_id = "${aws_eip.EIP1.id}"
  subnet_id     = "${aws_subnet.NATGWSubnetAz1.id}"
  depends_on = ["aws_vpc.main", "aws_internet_gateway.InternetGateway"]
}

resource "aws_nat_gateway" "NAT2" {
  count = "${var.NATGateway == 1 ? 1 : 0}"
  allocation_id = "${aws_eip.EIP2.id}"
  subnet_id     = "${aws_subnet.NATGWSubnetAz2.id}"
  depends_on = ["aws_vpc.main", "aws_internet_gateway.InternetGateway"]
}

resource "aws_nat_gateway" "NAT3" {
  count = "${var.NATGateway * var.NumberOfAzs == 3 ? 1: 0}"
  allocation_id = "${aws_eip.EIP3.id}"
  subnet_id     = "${aws_subnet.NATGWSubnetAz3.id}"
  depends_on = ["aws_vpc.main", "aws_internet_gateway.InternetGateway"]
}

resource "aws_nat_gateway" "NAT4" {
  count = "${var.NATGateway * var.NumberOfAzs == 4 ? 1: 0}"
  allocation_id = "${aws_eip.EIP4.id}"
  subnet_id     = "${aws_subnet.NATGWSubnetAz4.id}"
  depends_on = ["aws_vpc.main", "aws_internet_gateway.InternetGateway"]
}

resource "aws_subnet" "MGMTSubnetAz1" {
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = true
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.MgmtSubnetIpBlocks[0]}"
  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "MGMTSubnetAz1"))}"
    Network = "MGMT"
  }
}

resource "aws_subnet" "MGMTSubnetAz2" {
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = true
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.MgmtSubnetIpBlocks[1]}"
  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "MGMTSubnetAz2"))}"
    Network = "MGMT"
  }
}

resource "aws_subnet" "MGMTSubnetAz3" {
  count = "${var.NumberOfAzs >= 3 ? 1 : 0}"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"
  map_public_ip_on_launch = true
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.MgmtSubnetIpBlocks[2]}"
  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "MGMTSubnetAz3"))}"
    Network = "MGMT"
  }
}


resource "aws_subnet" "MGMTSubnetAz4" {
  count = "${var.NumberOfAzs == 4 ? 1 : 0}"
  availability_zone = "${data.aws_availability_zones.available.names[3]}"
  map_public_ip_on_launch = true
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.MgmtSubnetIpBlocks[3]}"
  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "MGMTSubnetAz4"))}"
    Network = "MGMT"
  }
}

resource "aws_internet_gateway" "InternetGateway" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Application = "${var.StackName}"
    Network =  "MGMT"
    Name = "${join("-", list(var.StackName, "InternetGateway"))}"
  }
}

resource "aws_route_table" "NATGWRouteTableAz1" {
  count = "${var.NATGateway}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "NATGWRouteTableAz1"))}"
  }
}

resource "aws_route_table" "NATGWRouteTableAz2" {
  count = "${var.NATGateway}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "NATGWRouteTableAz2"))}"
  }
}

resource "aws_route_table" "NATGWRouteTableAz3" {
  count = "${var.NumberOfAzs * var.NATGateway == 3 ? 1 : 0}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "NATGWRouteTableAz3"))}"
  }
}

resource "aws_route_table" "NATGWRouteTableAz4" {
  count = "${var.NumberOfAzs * var.NATGateway == 4 ? 1 : 0}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "NATGWRouteTableAz4"))}"
  }
}

resource "aws_route" "NATGWRoute1" {
  count = "${var.NATGateway}"
  route_table_id               = "${aws_route_table.NATGWRouteTableAz1.id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.InternetGateway.id}"
}

resource "aws_route" "NATGWRoute2" {
  count = "${var.NATGateway}"
  route_table_id               = "${aws_route_table.NATGWRouteTableAz2.id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.InternetGateway.id}"
}

resource "aws_route" "NATGWRoute3" {
  count = "${var.NumberOfAzs * var.NATGateway == 3 ? 1 : 0}"
  route_table_id               = "${aws_route_table.NATGWRouteTableAz3.id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.InternetGateway.id}"
}

resource "aws_route_table" "MGMTRouteTableAz1" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "MGMTRouteTableAz1"))}"
  }
}

resource "aws_route_table" "MGMTRouteTableAz2" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "MGMTRouteTableAz2"))}"
  }
}

resource "aws_route_table" "MGMTRouteTableAz3" {
  count = "${var.NumberOfAzs * var.NATGateway == 3 ? 1 : 0}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "MGMTRouteTableAz3"))}"
  }
}

resource "aws_route_table" "MGMTRouteTableAz4" {
  count = "${var.NumberOfAzs * var.NATGateway == 4 ? 1 : 0}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "MGMTRouteTableAz4"))}"
  }
}

resource "aws_route" "MGMTRoute1" {
  count = "${var.NATGateway == 0 ? 1 : 0}"
  route_table_id               = "${aws_route_table.MGMTRouteTableAz1.id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.InternetGateway.id}"
  depends_on = ["aws_route_table.MGMTRouteTableAz1"]
}

resource "aws_route" "MGMTRoute2" {
  count = "${var.NATGateway == 0 ? 1 : 0}"
  route_table_id               = "${aws_route_table.MGMTRouteTableAz2.id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.InternetGateway.id}"
  depends_on = ["aws_route_table.MGMTRouteTableAz2"]
}

resource "aws_route" "MGMTRoute3" {
  count = "${(var.NATGateway * var.NumberOfAzs) + var.NumberOfAzs == 3 ? 1 : 0}"
  route_table_id               = "${aws_route_table.MGMTRouteTableAz3.id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.InternetGateway.id}"
}

resource "aws_route" "MGMTRoute4" {
  count = "${(var.NATGateway * var.NumberOfAzs) + var.NumberOfAzs == 4 ? 1 : 0}"
  route_table_id               = "${aws_route_table.MGMTRouteTableAz4.id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.InternetGateway.id}"
}

resource "aws_route" "LambdaRoute1" {
  count = "${var.NATGateway}"
  route_table_id               = "${aws_route_table.LambdaRouteTableAz1.id}"
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.NAT1.id}"
}

resource "aws_route" "LambdaRoute2" {
  count = "${var.NATGateway}"
  route_table_id               = "${aws_route_table.LambdaRouteTableAz2.id}"
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.NAT2.id}"
}

resource "aws_route" "LambdaRoute3" {
  count = "${var.NATGateway * var.NumberOfAzs == 3 ? 1: 0}"
  route_table_id               = "${aws_route_table.LambdaRouteTableAz3.id}"
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.NAT3.id}"
}

resource "aws_route" "LambdaRoute4" {
  count = "${var.NATGateway * var.NumberOfAzs == 4 ? 1: 0}"
  route_table_id               = "${aws_route_table.LambdaRouteTableAz4.id}"
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.NAT4.id}"
}

resource "aws_route" "MGMTRouteNAT1" {
  count = "${var.NATGateway}"
  route_table_id               = "${aws_route_table.MGMTRouteTableAz1.id}"
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.NAT1.id}"
}

resource "aws_route" "MGMTRouteNAT2" {
  count = "${var.NATGateway * var.NumberOfAzs == 2 ? 1: 0}"
  route_table_id               = "${aws_route_table.MGMTRouteTableAz2.id}"
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.NAT2.id}"
}

resource "aws_route" "MGMTRouteNAT3" {
  count = "${var.NATGateway * var.NumberOfAzs == 3 ? 1: 0}"
  route_table_id               = "${aws_route_table.MGMTRouteTableAz3.id}"
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.NAT3.id}"
}

resource "aws_route" "MGMTRouteNAT4" {
  count = "${var.NATGateway * var.NumberOfAzs == 4 ? 1: 0}"
  route_table_id               = "${aws_route_table.MGMTRouteTableAz4.id}"
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.NAT4.id}"
}

resource "aws_route_table_association" "LambdaSubnetRouteTableAssociation1" {
  count = "${var.NATGateway}"
  subnet_id      = "${aws_subnet.LambdaSubnetAz1.id}"
  route_table_id = "${aws_route_table.LambdaRouteTableAz1.id}"
}

resource "aws_route_table_association" "LambdaSubnetRouteTableAssociation2" {
  count = "${var.NATGateway * var.NumberOfAzs == 2 ? 1: 0}"
  subnet_id      = "${aws_subnet.LambdaSubnetAz2.id}"
  route_table_id = "${aws_route_table.LambdaRouteTableAz2.id}"
}

resource "aws_route_table_association" "LambdaSubnetRouteTableAssociation3" {
  count = "${var.NATGateway * var.NumberOfAzs == 3 ? 1: 0}"
  subnet_id      = "${aws_subnet.LambdaSubnetAz3.id}"
  route_table_id = "${aws_route_table.LambdaRouteTableAz3.id}"
}

resource "aws_route_table_association" "LambdaSubnetRouteTableAssociation4" {
  count = "${var.NATGateway * var.NumberOfAzs == 4 ? 1: 0}"
  subnet_id      = "${aws_subnet.LambdaSubnetAz4.id}"
  route_table_id = "${aws_route_table.LambdaRouteTableAz4.id}"
}

resource "aws_route_table_association" "MGMTSubnetRouteTableAssociation1" {
  count = "${var.NATGateway == 0 ? 1 : 0}"
  subnet_id      = "${aws_subnet.MGMTSubnetAz1.id}"
  route_table_id = "${aws_route_table.MGMTRouteTableAz1.id}"
}

resource "aws_route_table_association" "MGMTSubnetRouteTableAssociation2" {
  count = "${var.NATGateway == 0 ? 1 : 0}"
  subnet_id      = "${aws_subnet.MGMTSubnetAz2.id}"
  route_table_id = "${aws_route_table.MGMTRouteTableAz2.id}"
}

resource "aws_route_table_association" "MGMTSubnetRouteTableAssociation3" {

  count = "${(var.NATGateway * 3) + var.NumberOfAzs == 3 ? 1 : 0}"
  subnet_id      = "${aws_subnet.MGMTSubnetAz3.id}"
  route_table_id = "${aws_route_table.MGMTRouteTableAz3.id}"
}

resource "aws_route_table_association" "MGMTSubnetRouteTableAssociation4" {
  count = "${(var.NATGateway * 4) + var.NumberOfAzs == 4 ? 1 : 0}"
  subnet_id      = "${aws_subnet.MGMTSubnetAz4.id}"
  route_table_id = "${aws_route_table.MGMTRouteTableAz4.id}"
}

resource "aws_route_table_association" "NAT1SubnetRouteTableAssociation" {
  count = "${var.NATGateway}"
  subnet_id      = "${aws_subnet.NATGWSubnetAz1.id}"
  route_table_id = "${aws_route_table.NATGWRouteTableAz1.id}"
}

resource "aws_route_table_association" "NAT2SubnetRouteTableAssociation" {
  count = "${var.NATGateway}"
  subnet_id      = "${aws_subnet.NATGWSubnetAz2.id}"
  route_table_id = "${aws_route_table.NATGWRouteTableAz2.id}"
}

resource "aws_route_table_association" "NAT3SubnetRouteTableAssociation" {
  count = "${var.NATGateway * var.NumberOfAzs == 3 ? 1: 0}"
  subnet_id      = "${aws_subnet.NATGWSubnetAz3.id}"
  route_table_id = "${aws_route_table.NATGWRouteTableAz3.id}"
}

resource "aws_route_table_association" "NAT4SubnetRouteTableAssociation" {
  count = "${var.NATGateway * var.NumberOfAzs == 4 ? 1: 0}"
  subnet_id      = "${aws_subnet.NATGWSubnetAz4.id}"
  route_table_id = "${aws_route_table.NATGWRouteTableAz4.id}"
}

resource "aws_route_table_association" "MGMTSubnetRouteTableAssociationNAT1" {
  count = "${var.NATGateway}"
  subnet_id      = "${aws_subnet.MGMTSubnetAz1.id}"
  route_table_id = "${aws_route_table.MGMTRouteTableAz1.id}"
}

resource "aws_route_table_association" "MGMTSubnetRouteTableAssociationNAT2" {
  count = "${var.NATGateway}"
  subnet_id      = "${aws_subnet.MGMTSubnetAz2.id}"
  route_table_id = "${aws_route_table.MGMTRouteTableAz2.id}"
}

resource "aws_route_table_association" "MGMTSubnetRouteTableAssociationNAT3" {
  count = "${var.NATGateway * var.NumberOfAzs == 3 ? 1: 0}"
  subnet_id      = "${aws_subnet.MGMTSubnetAz3.id}"
  route_table_id = "${aws_route_table.MGMTRouteTableAz3.id}"
}

resource "aws_route_table_association" "MGMTSubnetRouteTableAssociationNAT4" {
  count = "${var.NATGateway * var.NumberOfAzs == 4 ? 1: 0}"
  subnet_id      = "${aws_subnet.MGMTSubnetAz4.id}"
  route_table_id = "${aws_route_table.MGMTRouteTableAz4.id}"
}

/*
  Create the Lambda subnet for the first AZ
*/
resource "aws_subnet" "UNTRUSTSubnet1" {

  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.UntrustSubnetIpBlocks[0]}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  tags {
        "Application" = "${var.StackName}"
        "Network"= "UntrustSubnet1"
        "Name" = "${join("-", list(var.StackName, "UNTRUSTSubnet1"))}"
  }
}

/*
*/
resource "aws_subnet" "UNTRUSTSubnet2" {

  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.UntrustSubnetIpBlocks[1]}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  tags {
        "Application" = "${var.StackName}"
        "Network"= "UntrustSubnet2"
        "Name" = "${join("-", list(var.StackName, "UNTRUSTSubnet2"))}"
  }
}

/*
*/
resource "aws_subnet" "UNTRUSTSubnet3" {
  count = "${var.NumberOfAzs >= 3 ? 1 : 0}"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.UntrustSubnetIpBlocks[2]}"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"
  tags {
        "Application" = "${var.StackName}"
        "Network"= "UntrustSubnet3"
        "Name" = "${join("-", list(var.StackName, "UNTRUSTSubnet3"))}"
  }
}

resource "aws_subnet" "UNTRUSTSubnet4" {
  count = "${var.NumberOfAzs == 4 ? 1 : 0}"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.UntrustSubnetIpBlocks[3]}"
  availability_zone = "${data.aws_availability_zones.available.names[3]}"
  tags {
        "Application" = "${var.StackName}"
        "Network"= "UntrustSubnet4"
        "Name" = "${join("-", list(var.StackName, "UNTRUSTSubnet4"))}"
  }
}

resource "aws_route_table" "UNTRUSTRouteTable" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Application = "${var.StackName}"
    "Network"= "UntrustSubnet4"
    "Name" = "${join("-", list(var.StackName, "UntrustRouteTable"))}"
  }
}

resource "aws_route" "UNTRUSTRoute" {
  route_table_id               = "${aws_route_table.UNTRUSTRouteTable.id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.InternetGateway.id}"
}

resource "aws_route_table_association" "UNTRUSTSubnetRouteTableAssociation1" {
  subnet_id      = "${aws_subnet.UNTRUSTSubnet1.id}"
  route_table_id = "${aws_route_table.UNTRUSTRouteTable.id}"
  depends_on = ["aws_route.UNTRUSTRoute"]
}

resource "aws_route_table_association" "UNTRUSTSubnetRouteTableAssociation2" {
  subnet_id      = "${aws_subnet.UNTRUSTSubnet2.id}"
  route_table_id = "${aws_route_table.UNTRUSTRouteTable.id}"
}

resource "aws_route_table_association" "UNTRUSTSubnetRouteTableAssociation3" {
  count = "${var.NumberOfAzs >= 3 ? 1 : 0}"
  subnet_id      = "${aws_subnet.UNTRUSTSubnet3.id}"
  route_table_id = "${aws_route_table.UNTRUSTRouteTable.id}"
}

resource "aws_route_table_association" "UNTRUSTSubnetRouteTableAssociation4" {
  count = "${var.NumberOfAzs == 4 ? 1 : 0}"
  subnet_id      = "${aws_subnet.UNTRUSTSubnet4.id}"
  route_table_id = "${aws_route_table.UNTRUSTRouteTable.id}"
}

/*
  Create the Trust subnet for the first AZ
*/
resource "aws_subnet" "TRUSTSubnet1" {

  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.TrustSubnetIpBlocks[0]}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  tags {
        "Application" = "${var.StackName}"
        "Network"= "TrustSubnet1"
        "Name" = "${join("-", list(var.StackName, "TRUSTSubnet1"))}"
  }
}

/*
*/
resource "aws_subnet" "TRUSTSubnet2" {

  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.TrustSubnetIpBlocks[1]}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  tags {
        "Application" = "${var.StackName}"
        "Network"= "TrustSubnet2"
        "Name" = "${join("-", list(var.StackName, "TRUSTSubnet2"))}"
  }
}

/*
*/
resource "aws_subnet" "TRUSTSubnet3" {
  count = "${var.NumberOfAzs >= 3 ? 1 : 0}"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.TrustSubnetIpBlocks[2]}"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"
  tags {
        "Application" = "${var.StackName}"
        "Network"= "TrustSubnet3"
        "Name" = "${join("-", list(var.StackName, "TRUSTSubnet3"))}"
  }
}

resource "aws_subnet" "TRUSTSubnet4" {
  count = "${var.NumberOfAzs == 4 ? 1 : 0}"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.TrustSubnetIpBlocks[3]}"
  availability_zone = "${data.aws_availability_zones.available.names[3]}"
  tags {
        "Application" = "${var.StackName}"
        "Network"= "UntrustSubnet4"
        "Name" = "${join("-", list(var.StackName, "TRUSTSubnet4"))}"
  }
}

resource "aws_route_table" "TrustRouteTable" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Application = "${var.StackName}"
    "Network"= "UntrustSubnet4"
    "Name" = "${join("-", list(var.StackName, "TrustRouteTable"))}"
  }
}

resource "aws_route" "TRUSTRoute" {
  route_table_id               = "${aws_route_table.TrustRouteTable.id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.InternetGateway.id}"
}

resource "aws_route_table_association" "TRUSTSubnetRouteTableAssociation1" {
  subnet_id      = "${aws_subnet.TRUSTSubnet1.id}"
  route_table_id = "${aws_route_table.TrustRouteTable.id}"
}

resource "aws_route_table_association" "TRUSTSubnetRouteTableAssociation2" {
  subnet_id      = "${aws_subnet.TRUSTSubnet2.id}"
  route_table_id = "${aws_route_table.TrustRouteTable.id}"
}

resource "aws_route_table_association" "TRUSTSubnetRouteTableAssociation3" {
  count = "${var.NumberOfAzs >= 3 ? 1 : 0}"
  subnet_id      = "${aws_subnet.TRUSTSubnet3.id}"
  route_table_id = "${aws_route_table.TrustRouteTable.id}"
}

resource "aws_route_table_association" "TRUSTSubnetRouteTableAssociation4" {
  count = "${var.NumberOfAzs == 4 ? 1 : 0}"
  subnet_id      = "${aws_subnet.TRUSTSubnet4.id}"
  route_table_id = "${aws_route_table.TrustRouteTable.id}"
}

resource "aws_security_group" "PublicLoadBalancerSecurityGroup" {
  name        = "PublicLoadBalancerSecurityGroup"
  description = "Public ELB Security Group with HTTP access on port 80 from the internet"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
*?
