output "subnets" {
  value = "${aws_subnet.public_subnet.*.id}"
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

output "subnet01" {
  value = "${element(aws_subnet.public_subnet.*.id, 1)}"
}

output "subnet02" {
  value = "${element(aws_subnet.public_subnet.*.id, 2)}"
}

output "subnet03" {
  value = "${element(aws_subnet.public_subnet.*.id, 3)}"
}
