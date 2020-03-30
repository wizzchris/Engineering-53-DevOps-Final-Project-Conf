variable "db_ami_id" {
}

variable "instance_type" {}

variable "security_group_db" {}


variable "private_subnets" {
  type = "list"
}

variable "user_data_pr" {
  description=""
}

variable "user_data_sd" {
  description=""
}
