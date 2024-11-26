# # variables.tf inside the ECS module
variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default = "jijun"
}
#
variable "region" {
  description = "AWS region"
  type        = string
  default = "eu-central-1"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
  default =  ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}



variable "alb_target_group_arn" {
  description = "ALB target group ARN"
  type        = string
}

variable "alb_security_group_id" {
  description = "ALB security group ID"
  type        = string
}


variable "db_address" {
  description = "db_address"
  type        = string
}

variable "db_name" {
  description = "db_name"
  type        = string
}

variable "db_username" {
  description = "db username"
  type        = string
}

variable "db_password_arn" {
  description = "db_secret_arn"
  type        = string
}

variable "db_secret_key_id" {
  description = "db_secret_key_id"
  type        = string
}



