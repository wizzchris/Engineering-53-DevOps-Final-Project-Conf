
provider "aws" {
  region = "eu-west-1"
}

data "aws_availability_zones" "available" {}

resource "aws_instance" "db_primary" {
  count                       = 1
  ami                         = "${var.db_ami_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "charlie-poullet-eng53-homepc"
  vpc_security_group_ids      = ["${var.security_group_db}"]
  subnet_id                   = "${element(var.subnets, count.index)}"     ####################### change to priv
  private_ip                  = "10.0.7.100"
  user_data                   = "${var.user_data_pr}"

  tags = {
    Name = "hamza-jason-Eng53-db_primary-${count.index + 1}"
  }
}

resource "aws_instance" "db_secondary-1" {
  availability_zone           = "${data.aws_availability_zones.available.names[1]}"
  ami                         = "${var.db_ami_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "charlie-poullet-eng53-homepc"
  vpc_security_group_ids      = ["${var.security_group_db}"]
  subnet_id                   = "${element(var.subnets, 1)}"         ########################### change tp priv!!!
  private_ip                  = "10.0.8.100" #need to match ip on user script
  user_data                   = "${var.user_data_sd}"

  tags = {
    Name = "hamza-jason-Eng53-db_secondary-1"
  }
}

resource "aws_instance" "db_secondary-2" {
  availability_zone           = "${data.aws_availability_zones.available.names[2]}"
  ami                         = "${var.db_ami_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "charlie-poullet-eng53-homepc"
  vpc_security_group_ids      = ["${var.security_group_db}"]
  subnet_id                   = "${element(var.subnets, 2)}"         ########################### change tp priv!!!
  private_ip                  = "10.0.9.100"
  user_data                   = "${var.user_data_sd}"

  tags = {
    Name = "hamza-jason-Eng53-db_secondary-2"
  }
}
