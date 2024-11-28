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

variable "private_subnets" {
  description = "private_subnets"
  type        = list(string)
  default = ["10.0.5.0/24", "10.0.6.0/24"]
}


