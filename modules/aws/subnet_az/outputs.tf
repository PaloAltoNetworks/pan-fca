output "subnet_id" {
  description = "Subnet ID"
  value       = "${aws_subnet.this.id}"
}

output "subnet_cidr_block" {
  description = "Subnet CIDR Block"
  value       = "${aws_subnet.this.cidr_block}"
}
