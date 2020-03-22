provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source        = "./vpc"
  vpc_cidr      = "10.0.0.0/16"
  public_cidrs  = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
  private_cidrs = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}

#load the init template
data "template_file" "db_init" {
  template = "${file("./scripts/db/init.sh.tpl")}"
}

# load the init template
data "template_file" "db2_init" {
  template = "${file("./scripts/db/init2.sh.tpl")}"
}

module "db" {
  source                = "./db"
  instance_type         = "t2.micro"
  security_group        = "${module.vpc.security_group}"
  private_subnets       = "${module.vpc.private_subnets}"
  app_ami_id            = "ami-02e24fbcca656fe37"
  user_data_pr          = "${data.template_file.db_init.rendered}"
  user_data_sd          = "${data.template_file.db2_init.rendered}"

}

#load the init template
data "template_file" "app_init" {
  template = "${file("./scripts/app/init.sh.tpl")}"
}

module "Autoscaling" {
  source            = "./Autoscaling"
  instance_type     = "t2.micro"
  app_ami_id        = "ami-02e24fbcca656fe37"
  aws_vpc_id        = "${module.vpc.aws_vpc_id}"
  subnets           = "${module.vpc.subnets}"
  user_data_app     = "${data.template_file.app_init.rendered}"
}

module "load_balancer" {
  source     = "./load_balancer"
  aws_vpc_id = "${module.vpc.aws_vpc_id}"
  subnets    = "${module.vpc.subnets}"
  asg        = "${module.Autoscaling.asg}"
}
