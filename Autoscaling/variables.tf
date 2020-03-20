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

# variable "subnet01" {}
# variable "subnet02" {}
# variable "subnet03" {}



variable "user_data_app" {
  description=""
  default=""
}
