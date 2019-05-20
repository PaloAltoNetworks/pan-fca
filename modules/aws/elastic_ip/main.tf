#EIP Module
resource "aws_eip" "new_ip" {
  count = "${length(var.availability_zones)}"
  vpc   = "${var.vpc_exist}"

  tags {
    Name = "az${element(var.availability_zones, count.index)}-${var.eip_type}-eip"
  }
}