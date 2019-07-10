// Create CGW and VPN connection for existing VPC / VGW


# Create CGW to each firewall
resource "aws_customer_gateway" "cgw" {
# Count from calculated var length is not working, need to fix
  count         = "1"
  bgp_asn       = "${var.customer_gw_asn}"
  ip_address    = "${var.customer_gw_ip}"
  type          = "ipsec.1"
  tags          = "${merge(map("Name", format("%s", var.name)), var.tags)}"
}


resource "aws_vpn_connection" "vgw_vpn" {
# Count from calculated var length is not working, need to fix
  count               = "${var.create_vpn_vgw != "" ? 1 : 0}"
  vpn_gateway_id      = "${var.vpn_gateway_id}"
  customer_gateway_id = "${element(aws_customer_gateway.cgw.*.id, count.index)}"
  type                = "ipsec.1"
  tunnel1_inside_cidr = "${var.tunnel1_inside_cidr}"
  tunnel2_inside_cidr = "${var.tunnel2_inside_cidr}"
  tunnel1_preshared_key = "${var.tunnel1_preshared_key}"
  tunnel2_preshared_key = "${var.tunnel2_preshared_key}"
  static_routes_only  = false
  tags          = "${merge(map("Name", format("%s", var.name)), var.tags)}"
}

resource "aws_vpn_connection" "tgw_vpn" {
# Count from calculated var length is not working, need to fix
  count               = "${var.create_vpn_tgw != "" ? 1 : 0}"
  transit_gateway_id      = "${var.transit_gateway_id}"
  customer_gateway_id = "${element(aws_customer_gateway.cgw.*.id, count.index)}"
  type                = "ipsec.1"
  tunnel1_inside_cidr = "${var.tunnel1_inside_cidr}"
  tunnel2_inside_cidr = "${var.tunnel2_inside_cidr}"
  tunnel1_preshared_key = "${var.tunnel1_preshared_key}"
  tunnel2_preshared_key = "${var.tunnel2_preshared_key}"
  static_routes_only  = false
  tags          = "${merge(map("Name", format("%s", var.name)), var.tags)}"
}