

################
# Create Route Table
################
resource "aws_route_table" "this" {
  vpc_id            = "${var.vpc_id}"
  tags              = "${merge(map("Name", format("%s", var.name)), var.tags)}"
}


################
# Routes
################

# Create route conditional on gateway type variable (igw, tgw, vgw, eni)

resource "aws_route" "default_igw" {
  count = "${var.create_route_to_igw != "" ? 1 : 0}"
  route_table_id         = "${aws_route_table.this.id}"
  destination_cidr_block = "${var.prefix}"
  gateway_id             = "${var.igw_next_hop}"
  timeouts {
    create = "5m"
  }
}

resource "aws_route" "default_vgw" {
  count = "${var.create_route_to_vgw != "" ? 1 : 0}"
  route_table_id         = "${aws_route_table.this.id}"
  destination_cidr_block = "${var.prefix}"
  gateway_id             = "${var.vgw_next_hop}"
  timeouts {
    create = "5m"
  }
}

resource "aws_route" "default_eni" {
  count = "${var.create_route_to_eni != "" ? 1 : 0}"
  route_table_id         = "${aws_route_table.this.id}"
  destination_cidr_block = "${var.prefix}"
  network_interface_id   = "${var.eni_next_hop}"
  timeouts {
    create = "5m"
  }
}

resource "aws_route" "default_tgw" {
  count = "${var.create_route_to_tgw != "" ? 1 : 0}"
  route_table_id         = "${aws_route_table.this.id}"
  destination_cidr_block = "${var.prefix}"
  transit_gateway_id     = "${var.tgw_next_hop}"
  timeouts {
    create = "5m"
  }
}

 