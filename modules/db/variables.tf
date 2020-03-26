variable "db_ami_id" {
}

variable "instance_type" {}

variable "security_group_db" {}


variable "private_subnets" {
  type = "list"
}

variable "subnets" {      ################# need to delete!!!!!
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

variable "user_data_sd2" {
  description=""
  default=""
}

variable "kn" {
}
