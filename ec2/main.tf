provider "aws" {
  region = "eu-west-1"
}

data "aws_availability_zones" "available" {}

resource "aws_instance" "app_instance" {
  count                       = 1
  ami                         = "${var.app_ami_id}"
  instance_type               = "${var.instance_type}"
  # key_name                    = "${aws_key_pair.my-key.id}"
  vpc_security_group_ids      = ["${var.security_group}"]
  subnet_id                   = "${element(var.subnets, count.index)}"
  associate_public_ip_address = true
  user_data = "${var.user_data}"


  tags = {
    Name = "hamza-jason-Eng53-instance-${count.index + 1}"
  }
}
