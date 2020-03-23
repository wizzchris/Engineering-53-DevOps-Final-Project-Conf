output "subnets" {
  value = "${aws_subnet.public_subnet.*.id}"
}

output "private_subnets" {
  value = "${aws_subnet.private_subnet.*.id}"
}

output "public_subnets_elk" {
  value = "${aws_subnet.public_subnet_elk.*.id}"
}

output "security_group" {
  value = "${aws_security_group.sg.id}"
}

output "security_group_elk" {
  value = "${aws_security_group.sg-elk.id}"
}

output "aws_vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "aws_internet_gateway" {
  value = "${aws_internet_gateway.gw.id}"
}
