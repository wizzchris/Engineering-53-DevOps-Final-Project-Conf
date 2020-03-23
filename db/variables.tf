variable "db_ami_id" {
  default="ami-01793b684af7a3e2c"
}

# variable "my_public_key" {
#
# }

variable "instance_type" {}

variable "security_group" {}


variable "private_subnets" {
  type = "list"
}

# variable "subnet01" {}
# variable "subnet02" {}
# variable "subnet03" {}


variable "user_data_pr" {
  description=""
  default=""
}

variable "user_data_sd" {
  description=""
  default=""
}
