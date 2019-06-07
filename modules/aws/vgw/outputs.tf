output "vgw_id" {
  description = "The ID of the VGW"
  value       = "${element(concat(aws_vpn_gateway.this.*.id, list("")), 0)}"
}