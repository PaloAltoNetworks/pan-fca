

################
# Create Route Table
################
resource "aws_route_table" "this" {
  vpc_id            = "${var.vpc_id}"
  tags              = "${merge(map("Name", format("%s", var.name)))}"
}


################
# Default Routes
################

# Create default route conditional on gateway type variable (igw, tgw, vgw, eni)

resource "aws_route" "default_igw" {
  count = "${var.default_igw != "" ? 1 : 0}"
  route_table_id         = "${aws_route_table.this.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${var.default_igw}"
  timeouts {
    create = "5m"
  }
}

resource "aws_route" "default_vgw" {
  count = "${var.default_vgw != "" ? 1 : 0}"
  route_table_id         = "${aws_route_table.this.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${var.default_vgw}"
  timeouts {
    create = "5m"
  }
}

resource "aws_route" "default_eni" {
  count = "${var.default_eni != "" ? 1 : 0}"
  route_table_id         = "${aws_route_table.this.id}"
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = "${var.default_eni}"
  timeouts {
    create = "5m"
  }
}

resource "aws_route" "default_tgw" {
  count = "${var.default_tgw != "" ? 1 : 0}"
  route_table_id         = "${aws_route_table.this.id}"
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = "${default_tgw}"
  timeouts {
    create = "5m"
  }
}

 