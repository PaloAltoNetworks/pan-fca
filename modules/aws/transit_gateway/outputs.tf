output "aws_ec2_transit_gateway_id" {
  value = "${aws_ec2_transit_gateway.tgw.id}"
}

output "aws_ec2_transit_gateway_asn" {
  value = "${aws_ec2_transit_gateway.tgw.*.amazon_side_asn}"
}

output "aws_ec2_transit_gateway_def_rt_id" {
  value = "${aws_ec2_transit_gateway.tgw.*.propagation_default_route_table_id}"
}
