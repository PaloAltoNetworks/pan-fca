output "aws_eip" {
  description = "Elastic IP Pubic Address"
  value       = "${element(concat(aws_eip.this.*.public_ip, list("")), 0)}"
}

output "aws_eip_alloc_id" {
  description = "Elastic IP Id"
  value       = "${element(concat(aws_eip.this.*.id, list("")), 0)}"
}