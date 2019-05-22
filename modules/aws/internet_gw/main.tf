###################
# Internet Gateway
###################
resource "aws_internet_gateway" "this" {
  vpc_id            = "${var.vpc_id}"
  tags              = "${merge(map("Name", format("%s", var.name)))}"
}