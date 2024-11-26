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

variable "db_name" {
  description = "Database username"
  type        = string
  default = "jijun"
}

variable "db_username" {
  description = "AWS region"
  type        = string
  default = "jijun"
}

# output "website_url" {
#   description = "The website URL."
#   value       = format("http://%s/users", aws_alb.this.dns_name)
# }


#
#
# variable "subnet1_cidr" {
#   description = "CIDR block for subnet 1"
#   type        = string
# }
#
# variable "subnet2_cidr" {
#   description = "CIDR block for subnet 2"
#   type        = string
# }
#
# variable "subnet3_cidr" {
#   description = "CIDR block for subnet 3"
#   type        = string
# }
# #
# variable "subnet4_cidr" {
#   description = "CIDR block for subnet 4"
#   type        = string
# }
#
# variable "subnet5_cidr" {
#   description = "CIDR block for subnet 5"
#   type        = string
# }
#
# variable "vpc_cidr" {
#   description = "CIDR block for the VPC"
#   type        = string
# }
#
# # variables.tf
#
