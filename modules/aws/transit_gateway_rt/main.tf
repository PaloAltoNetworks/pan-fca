//resource "aws_ec2_transit_gateway_route_table" "tgw-rt-existing" {
//  count = "${var.route_table_existing == 0 ? 0 : var.route_table_count}"
//  transit_gateway_id = "${var.tgw_id}"
//
//  tags = {
//    Name = "${var.tags}"
//  }
//}

resource "aws_ec2_transit_gateway_route_table" "tgw-rt-new" {
  count = "${var.route_table_new == 0 ? 0 : var.route_table_count}"
  transit_gateway_id = "${var.tgw_id}"

  tags = {
    Name = "${var.tags}"
  }
}

resource "aws_ec2_transit_gateway_route" "tgw-route-new" {
  count = "${var.route_count == "" ? 0 : var.route_count}"
  destination_cidr_block         = "${element(var.destination_cidr_block, count.index)}"
  transit_gateway_attachment_id  = "${element(var.transit_gateway_attachment_id, count.index)}"
  transit_gateway_route_table_id = "${element(aws_ec2_transit_gateway_route_table.tgw-rt-new.*.id, count.index)}"
}

resource "aws_ec2_transit_gateway_route" "tgw-route-existing" {
  count = "${var.route_count == "" ? 0 : var.route_count}"
  destination_cidr_block         = "${element(var.destination_cidr_block, count.index)}"
  transit_gateway_attachment_id  = "${element(var.transit_gateway_attachment_id, count.index)}"
  transit_gateway_route_table_id = "${var.tgw_rt_id}"
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-assoc-existing" {
  count = "${var.assoc_route_existing == 0 ? 0 : 1}"
  transit_gateway_attachment_id  = "${element(var.transit_gateway_attachment_id, count.index)}"
  transit_gateway_route_table_id = "${var.tgw_rt_id}"
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-assoc-new" {
  count = "${var.assoc_route_new == 0 ? 0 : 1}"
  transit_gateway_attachment_id  = "${element(var.transit_gateway_attachment_id, count.index)}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.tgw-rt-new.id}"
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-prop-existing" {
  count = "${var.prop_route_existing == 0 ? 0 : 1}"
  transit_gateway_attachment_id  = "${element(var.transit_gateway_attachment_id, count.index)}"
  transit_gateway_route_table_id = "${var.tgw_rt_id}"
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-prop-new" {
  count = "${var.prop_route_new == 0 ? 0 : 1}"
  transit_gateway_attachment_id  = "${element(var.transit_gateway_attachment_id, count.index)}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.tgw-rt-new.id}"
}