resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-attachment" {
  subnet_ids                                      = ["${var.attach_subnet_ids}"]
  transit_gateway_id                              = "${var.transit_gateway_id}"
  vpc_id                                          = "${var.vpc_id}"
  transit_gateway_default_route_table_association = "${var.transit_gateway_default_route_table_association}"
  transit_gateway_default_route_table_propagation = "${var.transit_gateway_default_route_table_propagation}"
  tags                                            = "${merge(map("Name", format("%s", var.name)), var.tags)}"
}
