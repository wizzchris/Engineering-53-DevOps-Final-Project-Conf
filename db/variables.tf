variable "app_ami_id" {
  default="ami-02e24fbcca656fe37"
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
