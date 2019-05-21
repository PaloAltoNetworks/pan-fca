# Get datasource for list of availability zones in region
data "aws_availability_zones" "available" {}


################
# Private subnet
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