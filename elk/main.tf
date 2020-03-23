
provider "aws" {
  region = "eu-west-1"
}

data "aws_availability_zones" "available" {}

# resource "aws_key_pair" "my-key" {
#   key_name = "aws-public-key"
#   public_key = "${file(var.my_public_key)}"
# }

resource "aws_instance" "elastic_search" {
  count                       = 1
  ami                         = "${var.es_ami_id}"
  instance_type               = "${var.instance_type}"
  vpc_security_group_ids      = ["${var.security_group_elk}"]
  subnet_id                   = "${element(var.public_subnets_elk, count.index)}"
  private_ip                  = ["172.16.10.100"]


  tags = {
    Name = "hamza-jason-Eng53-elasticsearch-${count.index + 1}"
  }
}

resource "aws_instance" "kibana" {
  count                       = 1
  ami                         = "${var.kb_ami_id}"
  instance_type               = "${var.instance_type}"
  vpc_security_group_ids      = ["${var.security_group}"]
  subnet_id                   = "${element(var.public_subnets_elk, count.index)}"
  private_ip                  = ["172.16.10.101"]


  tags = {
    Name = "hamza-jason-Eng53-kibana-${count.index + 1}"
  }
}

resource "aws_instance" "logstash" {
  count                       = 1
  ami                         = "${var.ls_ami_id}"
  instance_type               = "${var.instance_type}"
  vpc_security_group_ids      = ["${var.security_group_elk}"]
  subnet_id                   = "${element(var.public_subnets_elk, count.index)}"
  private_ip                  = ["172.16.10.102"]


  tags = {
    Name = "hamza-jason-Eng53-logstash-${count.index + 1}"
  }
}

resource "aws_instance" "beats" {
  count                       = 1
  ami                         = "${var.beats_ami_id}"
  instance_type               = "${var.instance_type}"
  vpc_security_group_ids      = ["${var.security_group_elk}"]
  subnet_id                   = "${element(var.public_subnets_elk, count.index)}"
  private_ip                  = ["172.16.10.103"]

  tags = {
    Name = "hamza-jason-Eng53-beats-${count.index + 1}"
  }
}
