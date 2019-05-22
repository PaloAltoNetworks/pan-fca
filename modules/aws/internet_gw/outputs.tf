output "igw_id" {
  description = "Internet GW ID"
  value       = "${element(concat(aws_internet_gateway.this.*.id, list("")), 0)}"
}