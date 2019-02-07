output "spoke_vpn_name" {
    value = "${element(concat(aws_vpn_connection.vpn.*.tags.Name, list("")), 0)}"
}

output "spoke_asn" {
    value = "${element(concat(aws_vpn_connection.vpn.*.tunnel1_bgp_asn, list("")), 0)}"
}

output "fw_tunnel_ips" {
    value = ["${aws_vpn_connection.vpn.*.tunnel1_cgw_inside_address}", "${aws_vpn_connection.vpn.tunnel2_cgw_inside_address}"]
}
output "vgw_tunnel_ips" {
    value = ["${aws_vpn_connection.vpn.*.tunnel1_vgw_inside_address}", "${aws_vpn_connection.vpn.tunnel2_vgw_inside_address}"]
}

output "vgw_public_ips" {
    value = ["${aws_vpn_connection.vpn.*.tunnel1_address}", "${aws_vpn_connection.vpn.tunnel2_address}"]
}

output "tunnel_psks" {
    value = ["${aws_vpn_connection.vpn.*.tunnel1_preshared_key}", "${aws_vpn_connection.vpn.tunnel2_preshared_key}"]
}