provider "aws" {
  region = "eu-west-1"
}

data "aws_availability_zones" "zone_available" {}


# VPC Creation
resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"

  tags = {
    Name = "hamza-jason-Eng53-New-vpc"
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

  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = "${aws_internet_gateway.gw.id}"
  # }
  tags = {
    Name = "hamza-jason-Eng53-public-route-table"
  }
}

 #Private Route table
 resource "aws_default_route_table" "private_route_table" {
  default_route_table_id = "${aws_vpc.main.default_route_table_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  tags = {
    Name = "hamza-jason-Eng53-private-route-table"
  }
 }

 # Create Public subnet Kibana
 resource "aws_subnet" "public_subnet_elk" {
   count                   = 1 # <= if you change the count, make sure to change the cidrs in variable file
   cidr_block              = "${var.public_cidrs_elk[count.index]}"
   vpc_id                  = "${aws_vpc.main.id}"
   availability_zone       = "${data.aws_availability_zones.zone_available.names[count.index]}"

   tags = {
     Name = "hamza-jason-public-subnet-elk.${count.index + 1}"
   }
 }
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


#Create private subnet
 resource "aws_subnet" "private_subnet" {
   count              = 3 # <= if you change the count, make sure to change the cidrs in variable file
   cidr_block         = "${var.private_cidrs[count.index]}"
   vpc_id             = "${aws_vpc.main.id}"
   map_public_ip_on_launch = false
   availability_zone  = "${data.aws_availability_zones.zone_available.names[count.index]}"

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
   route_table_id = "${aws_default_route_table.private_route_table.id}"
   subnet_id = "${aws_subnet.private_subnet.*.id[count.index]}"
   depends_on = ["aws_default_route_table.private_route_table", "aws_subnet.private_subnet"]
 }

########################################################

## SG for DB

# Create Security Group
resource "aws_security_group" "sg_db" {
  name   = "hamza-jason-Eng53-sg-db"
  vpc_id = "${aws_vpc.main.id}"
}

# Ingress Security Group Port 22
# resource "aws_security_group_rule" "ssh_inbound_access" {  ########## at end remove !!!!!!!!!
#   from_port         = 22
#   protocol          = "tcp"
#   security_group_id = "${aws_security_group.sg_db.id}"
#   to_port           = 22
#   type              = "ingress"
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "http_inbound_access" {
#   from_port         = 80
#   protocol          = "tcp"
#   security_group_id = "${aws_security_group.sg_db.id}"
#   to_port           = 80
#   type              = "ingress"
#   cidr_blocks       = ["0.0.0.0/0"]
# }

resource "aws_security_group_rule" "mongod_inbound_access" {
  from_port         = 27017
  protocol          = "tcp"
  security_group_id = "${aws_security_group.sg_db.id}"
  to_port           = 27017
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

#All outbound access
resource "aws_security_group_rule" "mongo_all_outbound_access" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.sg_db.id}"
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["10.0.0.0/16"]
}

########################################################

#### SG for elasticsearch and logstack

resource "aws_security_group" "sg_el" {
  name   = "hamza-jason-Eng53-sg_el"
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_security_group_rule" "el_eph_inbound_access" {
  from_port         = 1024
  protocol          = "tcp"
  security_group_id = "${aws_security_group.sg_el.id}"
  to_port           = 65535
  type              = "ingress"
  cidr_blocks       = ["10.0.0.0/16"]
}

resource "aws_security_group_rule" "el_eph_outbound_access" {
  from_port         = 1024
  protocol          = "tcp"
  security_group_id = "${aws_security_group.sg_el.id}"
  to_port           = 65535
  type              = "egress"
  cidr_blocks       = ["10.0.0.0/16"]
}

############################################################

#### SG for Kibana

resource "aws_security_group" "sg_k" {
  name   = "hamza-jason-Eng53-sg-k"
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_security_group_rule" "k_eph_inbound_access" {
  from_port         = 1024
  protocol          = "tcp"
  security_group_id = "${aws_security_group.sg_k.id}"
  to_port           = 65535
  type              = "ingress"
  cidr_blocks       = ["10.0.0.0/16"]
}

#All inbound access
resource "aws_security_group_rule" "k_all_inbound_access" {
  from_port         = 1024
  protocol          = "-1"
  security_group_id = "${aws_security_group.sg_k.id}"
  to_port           = 65535
  type              = "ingress"
  cidr_blocks       = ["188.213.137.212/32"]
}

resource "aws_security_group_rule" "k_eph_outbound_access" {
  from_port         = 1024
  protocol          = "tcp"
  security_group_id = "${aws_security_group.sg_k.id}"
  to_port           = 65535
  type              = "egress"
  cidr_blocks       = ["10.0.0.0/16"]
}

#All outbound access
resource "aws_security_group_rule" "k_all_outbound_access" {
  from_port         = 1024
  protocol          = "-1"
  security_group_id = "${aws_security_group.sg_k.id}"
  to_port           = 65535
  type              = "egress"
  cidr_blocks       = ["188.213.137.212/32"]
}

############################################################
