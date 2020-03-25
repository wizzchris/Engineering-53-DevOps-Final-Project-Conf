provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source        = "./vpc"
  vpc_cidr      = "10.0.0.0/16"
  public_cidrs  = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
  private_cidrs = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  public_cidrs_elk = ["10.0.13.0/24"]
}

#load the init template
data "template_file" "db_init" {
  template = "${file("./scripts/db/init.sh.tpl")}"
}

# load the init template
data "template_file" "db2_init" {
  template = "${file("./scripts/db/init2.sh.tpl")}"
}

data "aws_ami" "app" {
  executable_users = ["self"]
  most_recent      = trusted_signers
  owners           = ["self"]

  filter {
    name   = "Name"
    values = ["abdimalik-mao-eng53-nodejs-*"]
  }
}

data "aws_ami" "db" {
  executable_users = ["self"]
  most_recent      = trusted_signers
  owners           = ["self"]

  filter {
    name   = "Name"
    values = ["abdimalik-mao-eng53-db-*"]
  }
}


module "elk" {
  source                  = "./elk"
  security_groups         = ["${module.vpc.security_group_elk}"]
  vpc_id                  = "${module.vpc.aws_vpc_id}"
  subnet_ids              = [${module.vpc.public_subnets_elk}]
  instance_type           = "t2.small"
}

module "db" {
  source                = "./db"
  instance_type         = "t2.micro"
  # my_public_key         = "C:/Users/aws.pub"
  security_group        = "${module.vpc.security_group}"
  private_subnets       = "${module.vpc.private_subnets}"
  db_ami_id             = "${data.aws_ami.db.id}" #DB image
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
  app_ami_id        = "${data.aws_ami.app.id}"
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
