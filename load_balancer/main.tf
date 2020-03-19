provider "aws" {
  region = "eu-west-1"
}

resource "aws_lb" "lb" {
    name               = "hamza-jason-eng53-lb"
    internal           = false
   load_balancer_type = "application"
   subnets            =  "${var.subnets}"
 }

 resource "aws_lb_target_group" "tg1" {
     name     = "hamza-jason-eng53-tg1"
     port     = 80
     protocol = "HTTP"
     vpc_id   = "${var.aws_vpc_id}"
}
