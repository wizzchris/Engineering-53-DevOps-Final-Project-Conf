
provider "aws" {
  region = "eu-west-1"
}

data "aws_availability_zones" "available" {}

resource "aws_instance" "elastic_search" {
  count                       = 1
  ami                         = "${var.es_ami_id}"
  instance_type               = "${var.instance_type}"
  vpc_security_group_ids      = ["${var.security_group_k}"]
  subnet_id                   = "${element(var.public_subnets_elk, count.index)}"
  private_ip                  = "10.0.13.100"
  associate_public_ip_address = true
  key_name   = "charlie-poullet-eng53-homepc"
  
  tags = {
    Name = "hamza-jason-Eng53-elasticsearch-${count.index + 1}"
  }
}

resource "aws_instance" "kibana" {
  count                       = 1
  ami                         = "${var.kb_ami_id}"
  instance_type               = "${var.instance_type}"
  vpc_security_group_ids      = ["${var.security_group_k}"]
  subnet_id                   = "${element(var.public_subnets_elk, count.index)}"
  private_ip                  = "10.0.13.101"
  associate_public_ip_address = true
  key_name   = "charlie-poullet-eng53-homepc"


  tags = {
    Name = "hamza-jason-Eng53-kibana-${count.index + 1}"
  }
}

resource "aws_instance" "logstash" {
  count                       = 1
  ami                         = "${var.ls_ami_id}"
  instance_type               = "${var.instance_type}"
  vpc_security_group_ids       = ["${var.security_group_k}"]
  subnet_id                   = "${element(var.public_subnets_elk, count.index)}"
  private_ip                  = "10.0.13.102"
  associate_public_ip_address = true
  key_name   = "charlie-poullet-eng53-homepc"

  tags = {
    Name = "hamza-jason-Eng53-logstash-${count.index + 1}"
  }
}
