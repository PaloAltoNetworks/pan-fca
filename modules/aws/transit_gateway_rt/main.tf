//resource "aws_ec2_transit_gateway_route_table" "tgw-rt-existing" {
//  count = "${var.route_table_existing == 0 ? 0 : var.route_table_count}"
//  transit_gateway_id = "${var.tgw_id}"
//
//  tags = {
//    Name = "${var.tags}"
//  }
//}

resource "aws_ec2_transit_gateway_route_table" "tgw-rt-new" {
  transit_gateway_id = "${var.transit_gateway_id}"
  tags               = "${merge(map("Name", format("%s", var.name)), var.tags)}"
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-assoc-new" {
  count = "${var.associate_count}"
  transit_gateway_attachment_id  = "${element(var.associate_transit_gateway_attachment_id, count.index)}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.tgw-rt-new.id}"
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-prop-new" {
  count = "${var.propagate_count}"
  transit_gateway_attachment_id  = "${element(var.propagate_transit_gateway_attachment_id, count.index)}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.tgw-rt-new.id}"
}