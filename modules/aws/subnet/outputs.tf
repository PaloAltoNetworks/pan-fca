output "subnets_id" {
  description = "List of IDs of subnets"
  value       = ["${aws_subnet.this.*.id}"]
}

output "subnets_cidr" {
  description = "List of cidr_blocks of subnets"
  value       = ["${aws_subnet.this.*.cidr_block}"]
}
