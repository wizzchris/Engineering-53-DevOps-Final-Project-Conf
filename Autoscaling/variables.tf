variable "app_ami_id" {
    description = "ami image id"
}

variable "aws_vpc_id" {}

variable "instance_type" {
    description = "instance type"
}

variable "subnets" {
  type = "list"
}

variable "user_data" {
  description=""
  default=""
}
