provider "aws" {
  region = "eu-west-1"
}

# config launch configutations
resource "aws_launch_configuration" "hamza-jason-eng53-config1" {
  image_id                    = "${var.app_ami_id}"
  instance_type               = "${var.instance_type}"
  security_groups             = ["${aws_security_group.launch-config-asg-sg.id}"]
  associate_public_ip_address = true
  key_name                    = "charlie-poullet-eng53-homepc"
  user_data                   = "${var.user_data_app}"
}

# create autoscaling group
resource "aws_autoscaling_group" "hamza-jason-eng53-asg-1" {
  launch_configuration    = "${aws_launch_configuration.hamza-jason-eng53-config1.id}"
  vpc_zone_identifier     = ["${element(var.subnets, 0)}", "${element(var.subnets, 1)}", "${element(var.subnets, 2)}"]
  min_size                = 3
  max_size                = 3


  lifecycle {
    create_before_destroy = true
    }

  tag {
    key = "Name"
    value = "hamza-jason-eng53-app"
    propagate_at_launch = true
  }
}


resource "aws_security_group" "launch-config-asg-sg" {
    name = "launch-config-asg-sg"
    vpc_id = "${var.aws_vpc_id}"
}

resource "aws_security_group_rule" "inbound_http" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = "${aws_security_group.launch-config-asg-sg.id}"
    cidr_blocks = ["0.0.0.0/0"]
}

#### to delete
resource "aws_security_group_rule" "asg_inbound_http" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = "${aws_security_group.launch-config-asg-sg.id}"
    cidr_blocks = ["188.213.137.212/32"]
}
### myself
resource "aws_security_group_rule" "ascfdg_inbound_http" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = "${aws_security_group.launch-config-asg-sg.id}"
    cidr_blocks = ["86.164.234.169/32"]
}

resource "aws_security_group_rule" "outbound_all" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_group_id = "${aws_security_group.launch-config-asg-sg.id}"
    cidr_blocks = ["0.0.0.0/0"]
}
