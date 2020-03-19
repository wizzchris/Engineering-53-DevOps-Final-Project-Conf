variable "app_ami_id" {
  default="ami-02e24fbcca656fe37"
}

# variable "my_public_key" {
#
# }

variable "instance_type" {}

variable "security_group" {}

variable "subnets" {
  type = "list"
}


variable "user_data" {
  description=""
  default=""
}
