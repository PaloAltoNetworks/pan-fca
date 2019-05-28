##################################################
#### Create Network Security Group ####
##################################################
resource "aws_security_group" "this" {
  name        = "${var.name}"
  description = "${var.name}"
  vpc_id      = "${var.vpc_id}"
  tags        = "${merge(map("Name", format("%s", var.name)), var.tags)}"
}

resource "aws_security_group_rule" "this" {
  count            = "${length(var.rule_name) > 0 ? length(var.rule_name) : 0}"
  type             = "${var.type[count.index]}"
  from_port        = "${var.from_port[count.index]}"
  to_port          = "${var.to_port[count.index]}"
  description      = "${var.rule_name[count.index]}"
  protocol         = "${var.protocol[count.index]}"
  # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  cidr_blocks       = ["${var.cidr_blocks[count.index]}"]
  security_group_id = "${aws_security_group.this.id}"
}