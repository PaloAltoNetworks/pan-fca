resource "aws_subnet" "subscriber_subnet" {
  count = "${length(var.subscriber_subnets)}"
  vpc_id = "${var.vpc_id}"
  cidr_block = "${element(var.untrust_subnets, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"

  tags {
    Name = "${element(var.availability_zones, count.index)}-untrust-subnet"
  }
}

resource "aws_subnet" "untrust_subnet" {
  count = "${length(var.untrust_subnets)}"
  vpc_id = "${var.vpc_id}"
  cidr_block = "${element(var.untrust_subnets, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"

  tags {
    Name = "${element(var.availability_zones, count.index)}-untrust-subnet"
  }
}

resource "aws_subnet" "trust_subnet" {
  count = "${length(var.trust_subnets)}"
  vpc_id = "${var.vpc_id}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  cidr_block = "${element(var.trust_subnets, count.index)}"

  tags {
    Name = "${element(var.availability_zones, count.index)}-trust-subnet"
  }
}

resource "aws_subnet" "mgmt_subnet" {
  count = "${length(var.mgmt_subnets)}"
  vpc_id = "${var.vpc_id}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  cidr_block = "${element(var.mgmt_subnets, count.index)}"

  tags {
    Name = "${element(var.availability_zones, count.index)}-mgmt-subnet"
  }
}

resource "aws_default_route_table" "palo" {
  default_route_table_id = "${aws_vpc.palo.default_route_table_id}"

  tags {
    "Name" = "${join("", list(var.stack_name, "RT"))}"
  }
}

resource "aws_internet_gateway" "palo" {
  vpc_id = "${var.vpc_id}"

  tags {
    "Name" = "${join("", list(var.stack_name, "IGW"))}"
  }
}

resource "aws_route_table" "untrust_subnet" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.palo.id}"
  }

  tags {
    "Name" = "${join("", list(var.stack_name, "Untrust-RT"))}"
  }
}

resource "aws_route_table" "trust_subnet" {
  vpc_id = "${var.vpc_id}"

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


//EIP Creation
resource "aws_eip" "untrust_elastic_ip" {
  count      = "${length(var.availability_zones)}"
  vpc        = true

  tags {
    Name = "${element(var.availability_zones, count.index)}-untrust-eip"
  }
}

resource "aws_eip" "management_elastic_ip" {
  count      = "${length(var.availability_zones)}"
  vpc        = true

  tags {
    Name = "${element(var.availability_zones, count.index)}-mgmt-eip"
  }
}