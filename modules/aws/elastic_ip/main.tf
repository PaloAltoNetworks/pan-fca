resource "aws_eip" "this" {
  vpc               = true
  tags              = "${merge(map("Name", format("%s", var.name)), var.tags)}"
}

resource "aws_eip_association" "this" {
  network_interface_id = "${var.network_interface_id}"
  allocation_id        = "${element(aws_eip.this.*.id, count.index)}"
}