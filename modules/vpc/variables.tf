variable "vpc_cidr" {}

variable "public_cidrs" {
  type    = "list"
}


variable "private_cidrs" {
  type    = "list"
}

variable "public_cidrs_elk" {
  type = "list"
}
