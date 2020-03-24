provider "aws" {
  region = "eu-west-1"
}

#Builds VPC, Subnets, and SG
module "vpc" {
  source            = "./modules/vpc"
  vpc_cidr          = "10.0.0.0/16"
  public_cidrs      = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
  private_cidrs     = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  public_cidrs_elk  = ["10.0.13.0/24"]
}

#ELK STACK - creating instances
module "elk" {
  source                  = "./modules/elk"
  instance_type           = "t2.small"
  security_group_el       = "${module.vpc.security_group_el}"
  security_group_k        = "${module.vpc.security_group_k}"
  vpc_id                  = "${module.vpc.aws_vpc_id}"
  public_subnets_elk      = "${module.vpc.public_subnets_elk}"
  kb_ami_id               = "ami-0ff0f7f795ad437c7"
  ls_ami_id               = "ami-0372c9486de525240"
  es_ami_id               = "ami-0e2212b3311c42a29"

}

#load the init template for primary DB
data "template_file" "db_init" {
  template = "${file("./scripts/db/init.sh.tpl")}"
}

# load the init template for seconday DB
data "template_file" "db2_init" {
  template = "${file("./scripts/db/init2.sh.tpl")}"
}

#Building DB instances
module "db" {
  source                = "./modules/db"
  instance_type         = "t2.micro"
  security_group_db     = "${module.vpc.security_group_db}"
  private_subnets       = "${module.vpc.private_subnets}"
  db_ami_id             = "ami-0bef091281d85f90b" #DB image
  user_data_pr          = "${data.template_file.db_init.rendered}"
  user_data_sd          = "${data.template_file.db2_init.rendered}"
}

#load the init template for APP instance
data "template_file" "app_init" {
  template = "${file("./scripts/app/init.sh.tpl")}"
}

#creating Autoscaling groups
module "Autoscaling" {
  source            = "./modules/Autoscaling"
  instance_type     = "t2.micro"
  app_ami_id        = "ami-026d52f470975f02e"
  aws_vpc_id        = "${module.vpc.aws_vpc_id}"
  subnets           = "${module.vpc.subnets}"
  user_data_app     = "${data.template_file.app_init.rendered}"
}

# Creating LB and target groups
module "load_balancer" {
  source        = "./modules/load_balancer"
  aws_vpc_id    = "${module.vpc.aws_vpc_id}"
  subnets       = "${module.vpc.subnets}"
  asg           = "${module.Autoscaling.asg}"
}
