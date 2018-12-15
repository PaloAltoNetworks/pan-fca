# Create a new load balancer
resource "aws_elb" "PublicLoadBalancer" {
  count = "${var.NumberOfAzs == 2 ? 1: 0}"
  name            = "${var.ELBName}"
  internal        = false
  security_groups = ["${aws_security_group.PublicLoadBalancerSecurityGroup.id}"]
  subnets         = ["${aws_subnet.UNTRUSTSubnet1.id}", "${aws_subnet.UNTRUSTSubnet2.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  connection_draining = true
  connection_draining_timeout = 300

  idle_timeout = 300
  cross_zone_load_balancing = true

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 5
    target              = "HTTP:80/index.html"
    interval            = 30
  }
  depends_on = ["aws_vpc.main",
                "aws_security_group.PublicLoadBalancerSecurityGroup"]
}

# Create a new load balancer
resource "aws_elb" "PublicLoadBalancer3" {
  count = "${var.NumberOfAzs == 3 ? 1: 0}"
  name            = "${var.ELBName}"
  internal        = false
  security_groups = ["${aws_security_group.PublicLoadBalancerSecurityGroup.id}"]
  subnets         = ["${aws_subnet.UNTRUSTSubnet1.id}", "${aws_subnet.UNTRUSTSubnet2.id}",
                      "${aws_subnet.UNTRUSTSubnet3.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  connection_draining = true
  connection_draining_timeout = 300

  idle_timeout = 300
  cross_zone_loadbalancing = true

  enable_deletion_protection = true

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 5
    target              = "HTTP:80/index.html"
    interval            = 30
  }
  depends_on = ["aws_vpc.main",
                "aws_security_group.PublicLoadBalancerSecurityGroup"]
}
resource "aws_vpc_endpoint" "S3Endpoint2" {
  count = "${var.NumberOfAzs == 2 ? 1 : 0}"
  vpc_id       = "${aws_vpc.main.id}"
  service_name = "${join("", list("com.amazonaws.", "${var.aws_region}", ".s3"))}"
  route_table_ids = ["${aws_route_table.UNTRUSTRouteTable.id}"]

  policy = <<POLICY
{
        "Version":"2012-10-17",
        "Statement":[
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:ListBucket",
            "Resource": "${join("", list("arn:aws:s3:::", var.MasterS3Bucket))}"
        },
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "${join("", list("arn:aws:s3:::", var.MasterS3Bucket, "/*"))}"
        },
        {
          "Effect": "Allow",
          "Principal": "*",
          "Action": "*",
          "Resource": [
              "arn:aws:s3:::*.amazonaws.com",
              "arn:aws:s3:::*.amazonaws.com/*"
          ]
        }
        ]
}
POLICY
}

resource "aws_vpc_endpoint" "S3Endpoint3" {
  count = "${var.NumberOfAzs >= 3 ? 1 : 0}"
  vpc_id       = "${aws_vpc.main.id}"
  service_name = "${join("", list("com.amazonaws.", "${var.aws_region}", ".s3"))}"
  route_table_ids = "${aws_route_table.UNTRUSTRouteTable.id}"
  policy = <<POLICY
  {
        "Version":"2012-10-17",
        "Statement":[
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:ListBucket",
            "Resource": { "Fn::Join": [ "", [ "arn:aws:s3:::", { "Ref": "MasterS3Bucket" } ] ] }
        },
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": { "Fn::Join": [ "", [ "arn:aws:s3:::", { "Ref": "MasterS3Bucket" }, "/*" ] ] }
        }
        ],
      "RouteTableIds" : [ {"Ref" : "UNTRUSTRouteTable"}],
      "ServiceName" : { "Fn::Join": [ "", [ "com.amazonaws.", { "Ref": "AWS::Region" }, ".s3" ] ] },
      "VpcId" : {"Ref" : "VPC"}
   }
   POLICY
}

resource "aws_vpc_endpoint" "S3Endpoint4" {
  count = "${var.NumberOfAzs == 4 ? 1 : 0}"
  vpc_id       = "${aws_vpc.main.id}"
  service_name = "${join("com.amazonaws.", "${var.aws_region}", ".s3")}"
  route_table_ids = "${aws_route_table.UNTRUSTRouteTable.id}"
  policy = <<POLICY
  {
        "Version":"2012-10-17",
        "Statement":[
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:ListBucket",
            "Resource": { "Fn::Join": [ "", [ "arn:aws:s3:::", { "Ref": "MasterS3Bucket" } ] ] }
        },
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": { "Fn::Join": [ "", [ "arn:aws:s3:::", { "Ref": "MasterS3Bucket" }, "/*" ] ] }
        }
        ]
      },
      "RouteTableIds" : [ {"Ref" : "UNTRUSTRouteTable"}],
      "ServiceName" : { "Fn::Join": [ "", [ "com.amazonaws.", { "Ref": "AWS::Region" }, ".s3" ] ] },
      "VpcId" : {"Ref" : "VPC"}
   }
   POLICY
}

resource "aws_security_group" "PrivateLoadBalancerSecurityGroup" {
  name        = "PrivateLoadBalancerSecurityGroup"
  description = "Private ALB Security Group with HTTP access on port 80 from the VM-Series firewall fleet"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = "80"
    to_port         = "80"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Create a new load balancer
resource "aws_alb" "PrivateElasticLoadBalancer" {
  count = "${var.NumberOfAzs == 2 ? 1: 0}"
  name            = "${var.ILBName}"
  internal        = true
  security_groups = ["${aws_security_group.PrivateLoadBalancerSecurityGroup.id}"]
  subnets         = ["${aws_subnet.TRUSTSubnet1.id}", "${aws_subnet.TRUSTSubnet2.id}"]

  depends_on = ["aws_vpc.main",
                "aws_security_group.PrivateLoadBalancerSecurityGroup"]
}

# Create a new load balancer
resource "aws_alb" "PrivateElasticLoadBalancer3" {
  count = "${var.NumberOfAzs >= 3 ? 1: 0}"
  name            = "${var.ILBName}"
  internal        = true
  security_groups = ["${aws_security_group.PrivateLoadBalancerSecurityGroup.id}"]
  subnets         = ["${aws_subnet.TRUSTSubnet1.id}", "${aws_subnet.TRUSTSubnet2.id}",
                      "${aws_subnet.TRUSTSubnet3.id}"]

  depends_on = ["aws_vpc.main",
                "aws_security_group.PrivateLoadBalancerSecurityGroup"]
}

resource "aws_security_group" "WebServerSecurityGroup" {
  name        = "WebServerSecurityGroup"
  description = "Private ALB Security Group with HTTP access on port 80 from the VM-Series firewall fleet"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["${var.SSHLocation}"]
  }

  ingress {
    from_port       = "0"
    to_port         = "0"
    protocol        = "-1"
    cidr_blocks     = ["${var.VPCCIDR}"]
  }

  egress {
    from_port       = "0"
    to_port         = "0"
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_group" "WebServerGroup" {
  count = "${var.NumberOfAzs == 2 ? 1 : 0}"
  depends_on = ["aws_vpc.main",
                "aws_internet_gateway.InternetGateway",
                "aws_subnet.TRUSTSubnet1", "aws_subnet.TRUSTSubnet2"]

  availability_zones        = ["${data.aws_availability_zones.available.names[0]}",
                                "${data.aws_availability_zones.available.names[1]}"
                              ]
  name                      = "WebServerGroup"
  max_size                  = "6"
  min_size                  = "2"
  launch_configuration      = "${aws_launch_configuration.WebServerLaunchConfig.name}"
  target_group_arns         = ["${aws_alb_target_group.WebServerTargetGroup.arn}"]
  vpc_zone_identifier       = ["${aws_subnet.TRUSTSubnet1.id}", "${aws_subnet.TRUSTSubnet2.id}"]

  tag {
    key = "ResourceType"
    value  = "auto-scaling-group"
    key = "ResourceId"
    value = "WebServerGroup"
    key                 = "Name"
    value               = "${join("-", list(var.StackName, "WebServerGroup"))}"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "WebServerGroup3" {
  count = "${var.NumberOfAzs >= 3 ? 1 : 0}"
  dependson = ["aws_vpc.main",
                "aws_internet_gateway.InternetGateway",
                "aws_subnet.TRUSTSubnet1", "aws_subnet.TRUSTSubnet2",
                "aws_subnet.TRUSTSubnet3"]

  availability_zones        = ["${data.aws_availability_zones.available.names[0]}",
                                "${data.aws_availability_zones.available.names[1]}",
                                "${data.aws_availability_zones.available.names[2]}"
                              ]
  name                      = "WebServerGroup3"
  max_size                  = "2"
  min_size                  = "6"
  launch_configuration      = "${aws_launch_configuration.WebServerLaunchConfig.name}"
  target_group_arns         = ["${aws_alb_target_group.WebServerTargetGroup.arn}"]
  vpc_zone_identifier       = ["${aws_subnet.TRUSTSubnet1.id}",
                                "${aws_subnet.TRUSTSubnet2.id}",
                                "${aws_subnet.TRUSTSubnet3.id}"
                              ]

  tag {
    key = "ResourceType"
    value = "auto-scaling-group"
    key = "ResourceId"
    value  = "WebServerGroup3"
    key                 = "Name"
    value               = "${join("-", list(var.StackName, "WebServerGroup3"))}"
    propagate_at_launch = true
  }
}

resource "aws_alb_target_group" "WebServerTargetGroup" {
  name = "${join("-", list(var.StackName, "WebServerTargetGroup"))}"
  port = 80
  protocol = "HTTP"
  vpc_id = "${aws_vpc.main.id}"

  health_check {
    path = "/index.html"
    port = "80"
    protocol = "HTTP"
    timeout = "10"
    healthy_threshold = "5"
    unhealthy_threshold = "3"
    matcher = "200"
  }
}

/* */
resource "aws_alb_listener" "WebServerListener" {
  count = "${var.NumberOfAzs == 2 ? 1 : 0}"
  load_balancer_arn = "${aws_alb.PrivateElasticLoadBalancer.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.WebServerTargetGroup.arn}"
    type = "forward"
  }
}
/* */
resource "aws_alb_listener" "WebServerListener3" {
  count = "${var.NumberOfAzs >= 3 ? 1 : 0}"

  default_action {
    target_group_arn = "${aws_alb_target_group.WebServerTargetGroup.arn}"
    type = "forward"
  }
  load_balancer_arn = "${aws_alb.PrivateElasticLoadBalancer3.arn}"
  port              = "80"
  protocol          = "HTTP"
}

resource "aws_launch_configuration" "WebServerLaunchConfig" {
  depends_on = ["aws_vpc.main", "aws_internet_gateway.InternetGateway"]

  name = "WebServerLaunchConfig"
  image_id = "${var.WebServerImageId}"
  instance_type = "${var.InstanceType}"
  security_groups = ["${aws_security_group.WebServerSecurityGroup.id}"]
  user_data = "${file("./webserver_config_amzn_ami.sh")}"
  key_name = "${var.KeyName}"
  associate_public_ip_address = true
}

resource "aws_autoscaling_policy" "WebServerScaleUpPolicy" {
  count = "${var.NumberOfAzs == 2 ? 1: 0}"
  name                   = "WebServerScaleUpPolicy"
  scaling_adjustment     = "1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "60"
  autoscaling_group_name = "${aws_autoscaling_group.WebServerGroup.name}"
}

resource "aws_autoscaling_policy" "WebServerScaleDownPolicy" {
  count = "${var.NumberOfAzs == 2 ? 1: 0}"
  name                   = "WebServerScaleDownPolicy"
  scaling_adjustment     = "-1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "60"
  autoscaling_group_name = "${aws_autoscaling_group.WebServerGroup.name}"
}

resource "aws_autoscaling_policy" "WebServerScaleUpPolicy3" {
  count = "${var.NumberOfAzs >= 3 ? 1: 0}"
  name                   = "WebServerScaleUpPolicy3"
  scaling_adjustment     = "1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "60"
  autoscaling_group_name = "${aws_autoscaling_group.WebServerGroup3.name}"
}

resource "aws_autoscaling_policy" "WebServerScaleDownPolicy3" {
  count = "${var.NumberOfAzs >= 3 ? 1: 0}"
  name                   = "WebServerScaleDownPolicy3"
  scaling_adjustment     = "-1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "60"
  autoscaling_group_name = "${aws_autoscaling_group.WebServerGroup3.name}"
}

resource "aws_cloudwatch_metric_alarm" "CPUAlarmHigh" {
  count = "${var.NumberOfAzs == 2 ? 1: 0}"
  alarm_name                = "CPUAlarmHigh"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "90"
  alarm_description         = "Scale-up if CPU > 90% for 10 minutes"
  insufficient_data_actions = []
  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.WebServerGroup.name}"
  }
  alarm_actions = ["${aws_autoscaling_policy.WebServerScaleUpPolicy.arn}"]

}

resource "aws_cloudwatch_metric_alarm" "CPUAlarmLow" {
  count = "${var.NumberOfAzs == 2 ? 1: 0}"
  alarm_name                = "CPUAlarmLow"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "70"
  alarm_description         = "Scale-down if CPU < 70% for 10 minutes"
  insufficient_data_actions = []
  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.WebServerGroup.name}"
  }
  alarm_actions = ["${aws_autoscaling_policy.WebServerScaleDownPolicy.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "CPUAlarmHigh3" {
  count = "${var.NumberOfAzs >= 3 ? 1: 0}"
  alarm_name                = "CPUAlarmHigh3"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "90"
  alarm_description         = "Scale-up if CPU > 90% for 10 minutes"
  insufficient_data_actions = []
  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.WebServerGroup3.name}"
  }
  alarm_actions = ["${aws_autoscaling_policy.WebServerScaleUpPolicy3.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "CPUAlarmLow3" {
  count = "${var.NumberOfAzs >= 3 ? 1: 0}"
  alarm_name                = "CPUAlarmLow3"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "70"
  alarm_description         = "Scale-down if CPU < 70% for 10 minutes"
  insufficient_data_actions = []
  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.WebServerGroup3.name}"
  }
  alarm_actions = ["${aws_autoscaling_policy.WebServerScaleDownPolicy3.arn}"]
}

/*
resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["${aws_subnet.public.*.id}"]

  enable_deletion_protection = true

  tags {
    Environment = "production"
  }
}