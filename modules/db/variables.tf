variable "db_ami_id" {
  default="ami-01793b684af7a3e2c"
}

variable "instance_type" {}

variable "security_group_db" {}


variable "private_subnets" {
  type = "list"
}

variable "user_data_pr" {
  description=""
  default=""
}

variable "user_data_sd" {
  description=""
  default=""
}
