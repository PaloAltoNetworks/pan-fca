##############
# VPN Gateway
##############
resource "aws_vpn_gateway" "this" {
  vpc_id            = "${var.vpc_id}"
  amazon_side_asn   = "${var.amazon_side_asn}"

  tags = "${merge(map("Name", format("%s", var.name)))}"
}

resource "aws_vpn_gateway_attachment" "this" {
  vpc_id            = "${var.vpc_id}"
  vpn_gateway_id    = "${aws_vpn_gateway.this.id}"
}
