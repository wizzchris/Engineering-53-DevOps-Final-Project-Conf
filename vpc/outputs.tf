output "subnets" {
  value = "${aws_subnet.public_subnet.*.id}"
}

output "private_subnets" {
  value = "${aws_subnet.private_subnet.*.id}"
}

output "security_group" {
  value = "${aws_security_group.sg.id}"
}

output "aws_vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "aws_internet_gateway" {
  value = "${aws_internet_gateway.gw.id}"
}
