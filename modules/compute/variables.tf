variable "project_name" {
  type = string
}

variable "web_subnet_ids" {
  type = list(string)
}

variable "app_subnet_ids" {
  type = list(string)
}

variable "web_sg_id" {
  type = string
}

variable "app_sg_id" {
  type = string
}

variable "web_target_group_arn" {
  type = string
}

variable "app_target_group_arn" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "instance_profile_name" {
  type = string
}