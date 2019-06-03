output "eni_id" {
  description = "Interface ID"
  value       = "${element(concat(aws_network_interface.this.*.id, list("")), 0)}"
}