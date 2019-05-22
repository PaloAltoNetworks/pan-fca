# Get datasource for list of availability zones in region
data "aws_availability_zones" "available" {}


################
# Create subnets
################
resource "aws_subnet" "this" {
  count = "${length(var.subnets) > 0 ? length(var.subnets) : 0}"
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${var.subnets[count.index]}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  tags {
  "Name"            = "${var.subnet_names[count.index]}"
  }
}

##########################
# Route table association
##########################
resource "aws_route_table_association" "this" {
  count = "${length(var.subnets) > 0 ? length(var.subnets) : 0}"  
  subnet_id      = "${element(aws_subnet.this.*.id, count.index)}"
  route_table_id = "${var.route_table_id}"
}