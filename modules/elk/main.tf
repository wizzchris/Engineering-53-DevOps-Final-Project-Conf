
provider "aws" {
  region = "eu-west-1"
}

data "aws_availability_zones" "available" {}

resource "aws_instance" "elastic_search" {
  ami                         = "${var.es_ami_id}"
  instance_type               = "${var.instance_type}"
  vpc_security_group_ids      = ["${var.security_group_k}"]
  subnet_id                   = "${element(var.public_subnets_elk, 0)}"
  private_ip                  = "10.0.13.100"
  associate_public_ip_address = true

  tags = {
    Name = "hamza-jason-Eng53-elasticsearch"
  }
}

resource "aws_instance" "kibana" {
  ami                         = "${var.kb_ami_id}"
  instance_type               = "${var.instance_type}"
  vpc_security_group_ids      = ["${var.security_group_k}"]
  subnet_id                   = "${element(var.public_subnets_elk, 1)}"
  private_ip                  = "10.0.13.101"
  associate_public_ip_address = true
  depends_on                  = ["aws_instance.elastic_search"]

  tags = {
    Name = "hamza-jason-Eng53-kibana"
  }
}

resource "aws_instance" "logstash" {
  ami                         = "${var.ls_ami_id}"
  instance_type               = "${var.instance_type}"
  vpc_security_group_ids       = ["${var.security_group_k}"]
  subnet_id                   = "${element(var.public_subnets_elk, 2)}"
  private_ip                  = "10.0.13.102"
  associate_public_ip_address = true
  depends_on                  = ["aws_instance.kibana"]
  tags = {
    Name = "hamza-jason-Eng53-logstash"
  }
}
