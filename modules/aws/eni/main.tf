###################
# Network Interface
###################
resource "aws_network_interface" "this" {
  subnet_id         = "${var.subnet_id}"
  source_dest_check = "${var.source_dest_check}"
  tags              = "${merge(map("Name", format("%s", var.name)))}"
}