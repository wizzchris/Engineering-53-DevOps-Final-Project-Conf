provider "aws" {
  region = "eu-west-1"
}

data "aws_availability_zones" "zone_available" {}


# VPC Creation

resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"

  tags = {
    Name = "hamza-jason-Eng53-vpc"
  }
}

# Creating Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "hamza-jason-Eng53-igw"
  }
}

# Public Route table

resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  tags = {
    Name = "hamza-jason-Eng53-public-route-table"
  }
}

 #Private Route table
 #resource "aws_default_route_table" "private_route_table" {
#   default_route_table_id = "${aws_vpc.main.default_route_table_id}"
#
#   tags = {
#     Name = "hamza-jason-Eng53-private-route-table"
#   }
 #}


# Create Public subnet
resource "aws_subnet" "public_subnet" {
  count                   = 3 # <= if you change the count, make sure to change the cidrs in variable file
  cidr_block              = "${var.public_cidrs[count.index]}"
  vpc_id                  = "${aws_vpc.main.id}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.zone_available.names[count.index]}"

  tags = {
    Name = "hamza-jason-public-subnet.${count.index + 1}"
  }
}

# Create private subnet
 resource "aws_subnet" "private_subnet" {
   count = 3 # <= if you change the count, make sure to change the cidrs in variable file
   cidr_block = "${var.private_cidrs[count.index]}"
   vpc_id = "${aws_vpc.main.id}"
   map_public_ip_on_launch = false
   availability_zone = "${data.aws_availability_zone.zone_available.names[count.index]}"

   tags = {
     Name = "hamza-jason-private-subnet.${count.index + 1}"
   }
 }


# Associate Public Subnet with Public Route table
resource "aws_route_table_association" "public_subnet_assoc" {
  count          = 3
  route_table_id = "${aws_route_table.public_route_table.id}"
  subnet_id      = "${aws_subnet.public_subnet.*.id[count.index]}"
  depends_on     = ["aws_route_table.public_route_table", "aws_subnet.public_subnet"]
}

# Associate Public Subnet with Public Route table
 resource "aws_route_table_association" "private_subnet_assoc" {
   count = 3
   route_table_id = "${aws_default_route_table.public_route_table.id}"
   subnet_id = "${aws.subnet.private_subnet.*.id[count.index]}"
   depends_on = ["aws_default_route_table.public_route_table", "aws_subnet.private_subnet"]
 }


# Create Security Group
resource "aws_security_group" "sg" {
  name   = "hamza-jason-Eng53-sg"
  vpc_id = "${aws_vpc.main.id}"
}

# Ingress Security Group Port 22
resource "aws_security_group_rule" "ssh_inbound_access" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.sg.id}"
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "http_inbound_access" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.sg.id}"
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

# All outbound access
resource "aws_security_group_rule" "all_outbound_access" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.sg.id}"
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}
