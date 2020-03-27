provider "aws" {
  region = "eu-west-1"
}

resource "aws_lb" "lb" {
    name               = "hamza-jason-eng53-lb"
    internal           = false
   load_balancer_type = "application"     
   subnets            =  "${var.subnets}"
   security_groups = ["${aws_security_group.lb_sg.id}"]
 }

resource "aws_lb_target_group" "tg1" {
   name     = "hamza-jason-eng53-tg1"
   port     = 80
   protocol = "HTTP"
   vpc_id   = "${var.aws_vpc_id}"
}

# Create a new LB Target Group attachment
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = "${var.asg.name}"
  alb_target_group_arn   = "${aws_lb_target_group.tg1.arn}"
}


#create a Load balancer listener
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.tg1.arn}"
  }
}

# Security group for lb
resource "aws_security_group" "lb_sg" {
name = "lb_sg"
vpc_id = "${var.aws_vpc_id}"
}

resource "aws_security_group_rule" "inbound_http" {
type = "ingress"
from_port = 80
to_port = 80
protocol = "tcp"
security_group_id = "${aws_security_group.lb_sg.id}"
cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_all" {
type = "egress"
from_port = 0
to_port = 0
protocol = "-1"
security_group_id = "${aws_security_group.lb_sg.id}"
cidr_blocks = ["0.0.0.0/0"]
}
