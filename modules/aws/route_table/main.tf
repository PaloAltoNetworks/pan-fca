

################
# Create Route Table
################
resource "aws_route_table" "this" {
  vpc_id            = "${var.vpc_id}"
  tags              = "${merge(map("Name", format("%s-${var.public_subnet_suffix}", var.name)), var.tags, var.public_route_table_tags)}"
}
