output "aws_eips" {
  value = ["${aws_eip.new_ip.*.public_ip}"]
}

output "aws_eip_alloc_id" {
  value = ["${aws_eip.new_ip.*.id}"]
}