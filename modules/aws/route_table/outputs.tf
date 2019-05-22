output "route_table_id" {
  description = "Route Table ID"
  value       = "${element(concat(aws_route_table.this.*.id, list("")), 0)}"
}