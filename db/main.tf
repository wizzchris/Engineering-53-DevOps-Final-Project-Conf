
provider "aws" {
  region = "eu-west-1"
}

data "aws_availability_zones" "available" {}

# resource "aws_key_pair" "my-key" {
#   key_name = "aws-public-key"
#   public_key = "${file(var.my_public_key)}"
# }

resource "aws_instance" "db_primary" {
  count                       = 1
  ami                         = "${var.db_ami_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "Hamza-ElAouane-Eng53-ire-key"
  vpc_security_group_ids      = ["${var.security_group}"]
  subnet_id                   = "${element(var.private_subnets, count.index)}"
  associate_public_ip_address = true
  user_data                   = "${var.user_data_pr}"

  tags = {
    Name = "hamza-jason-Eng53-db_primary-${count.index + 1}"
  }
}

resource "aws_instance" "db_secondary" {
  availability_zone           = "${data.aws_availability_zones.available.names[1]}"
  ami                         = "${var.db_ami_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "Hamza-ElAouane-Eng53-ire-key"
  vpc_security_group_ids      = ["${var.security_group}"]
  subnet_id                   = "${element(var.private_subnets, 1)}"
  associate_public_ip_address = true
  user_data                   = "${var.user_data_sd}"

  tags = {
    Name = "hamza-jason-Eng53-db_secondary-1"
  }
}

resource "aws_instance" "db_secondary-1" {
  availability_zone           = "${data.aws_availability_zones.available.names[2]}"
  ami                         = "${var.db_ami_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "Hamza-ElAouane-Eng53-ire-key"
  vpc_security_group_ids      = ["${var.security_group}"]
  subnet_id                   = "${element(var.private_subnets, 2)}"
  associate_public_ip_address = false
  user_data                   = "${var.user_data_sd}"

  tags = {
    Name = "hamza-jason-Eng53-db_secondary-2"
  }
}
