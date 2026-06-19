variable "project_name" {}
variable "aws_region" {}

variable "vpc_cidr" {}

variable "public_subnet_a_cidr" {}
variable "public_subnet_b_cidr" {}

variable "web_subnet_a_cidr" {}
variable "web_subnet_b_cidr" {}

variable "app_subnet_a_cidr" {}
variable "app_subnet_b_cidr" {}

variable "db_subnet_a_cidr" {}
variable "db_subnet_b_cidr" {}

variable "az_a" {}
variable "az_b" {}

variable "instance_type" {}

variable "key_name" {}

variable "db_name" {}

variable "db_username" {}

variable "db_password" {
  sensitive = true
}