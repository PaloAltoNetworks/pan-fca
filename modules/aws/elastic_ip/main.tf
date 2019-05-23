resource "aws_eip" "new_ip" {
  description = "Create a New EIP"
  vpc   = true
    tags {
  "Name"            = "${var.eip_type[count.index]}"
  }
}