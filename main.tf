provider "aws" {
  region = "eu-west-1"
}


module "vpc" {
  source       = "./vpc"
  vpc_cidr     = "10.0.0.0/16"
  public_cidrs = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
}

#load the init template
data "template_file" "app_init" {
  template = "${file("./scripts/app/init.sh.tpl")}"
}

module "ec2" {
  source = "./ec2"
  # my_public_key  = "C:/Users/aws.pub"
  instance_type  = "t2.micro"
  security_group = "${module.vpc.security_group}"
  subnets        = "${module.vpc.subnets}"
  app_ami_id     = "ami-02e24fbcca656fe37"

}

module "Autoscaling" {
  source = "./Autoscaling"
  # instance_type  = "t2.micro"
  # app_ami_id     = "ami-02e24fbcca656fe37"
  vpc_id    = "${module.vpc.aws_vpc_id}"
  subnets   = "${module.vpc.subnets}"
  subnet01  = "${module.vpc.subnet01}"
  subnet02  = "${module.vpc.subnet02}"
  subnet03  = "${module.vpc.subnet03}"
  user_data = "${data.template_file.app_init.rendered}"
}

####################### partially built-#################################

# resource "aws_lb" "load_balancer" {
#    name               = "hamza-jason-eng53-lb"
#    internal           = false
#   load_balancer_type = "application"
#   # security_groups    = []
#   # subnets            = []
#
#   resource "aws_lb_target_group" "tg1" {
#     name     = "hamza-jason-eng53-tg1"
#     port     = 80
#     protocol = "HTTP"
#     vpc_id   = "${}"
#
#   resource "aws_lb_target_group_attachment" "test" {
#     target_group_arn = "${}"
#     target_id        = "${}"
#     port             = 80
# #########################################################
