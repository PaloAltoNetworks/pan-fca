output "aws_ec2_transit_gateway_attachment_id" {
  value = "${aws_ec2_transit_gateway_vpc_attachment.tgw-attachment.*.id}"
}

output "aws_ec2_tgw_id" {
  value = "${aws_ec2_transit_gateway_vpc_attachment.tgw-attachment.*.transit_gateway_id}"
}