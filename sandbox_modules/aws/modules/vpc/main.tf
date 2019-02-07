// If availability zones are provided, use those, otherwise, use all available
locals {
  //aws_zones = ["${length(var.availability_zones) > 0 ? var.availability_zones : data.aws_availability_zones.default.names}"]
  // aws_zones = ["${split(",", length(join(",", var.availability_zones)) > 0 ? join(",", var.availablity_zones) : join(",", data.aws_availability_zones.default.names))}"] 
  #aws_zones = ["${var.region}a", "${var.region}b"]
  #aws_zones = ["${var.region}${element(var.availability_zones, count.index)}]
}

provider "aws" {
  region = "${var.region}"
}
// Create VPC Resource

resource "aws_vpc" "palo" {
  cidr_block = "${var.vpc_cidr}"
  tags = {
    "Name" = "${var.vpc_name}"
    "Application" = "${var.stack_name}"
  }
}

##################################################
#### Create Management Network Security Group ####
##################################################
resource "aws_security_group" "sgWideOpen" {
  name        = "sgWideOpen"
  description = "Wide open security group"
  vpc_id      = "${aws_vpc.palo.id}"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    "Name" = "SgWideOpen"
  }
}