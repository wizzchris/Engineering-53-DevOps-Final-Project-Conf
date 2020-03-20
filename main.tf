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
  source         = "./ec2"
  instance_type  = "t2.micro"
  security_group = "${module.vpc.security_group}"
  subnets        = "${module.vpc.subnets}"
  app_ami_id     = "ami-02e24fbcca656fe37"
  user_data      = "${data.template_file.app_init.rendered}"
}


module "Autoscaling" {
  source           = "./Autoscaling"
  instance_type    = "t2.micro"
  app_ami_id       = "ami-02e24fbcca656fe37"
  aws_vpc_id       = "${module.vpc.aws_vpc_id}"
  subnets          = "${module.vpc.subnets}"
  user_data        = "${data.template_file.app_init.rendered}"
}

module "load_balancer" {
  source           = "./load_balancer"
  aws_vpc_id       = "${module.vpc.aws_vpc_id}"
  subnets          = "${module.vpc.subnets}"
  asg              = "${module.Autoscaling.asg}"
}
