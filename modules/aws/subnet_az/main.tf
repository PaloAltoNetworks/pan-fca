

################
# Create subnet
################
resource "aws_subnet" "this" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${var.cidr_block}"
  availability_zone = "${var.availability_zone}"
  tags              = "${merge(map("Name", format("%s", var.name)), var.tags)}"
}

##########################
# Route table association
##########################
resource "aws_route_table_association" "this" {
  subnet_id      = "${element(aws_subnet.this.*.id, count.index)}"
  route_table_id = "${var.route_table_id}"
}