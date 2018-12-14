// Create VPN Gateway Resource
resource "aws_vpn_gateway" "palo_vpn" {
  vpc_id = "${var.vpc_id}"
  tags {
  "Name" = "${ var.vpc_id }"
  }
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