variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

# terraform/variables.tf
variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default = "qian-iac"
}

variable "region" {
  description = "region"
  type        = string
  default = "eu-central-1"
}

variable "subnet1_cidr" {
  description = "CIDR block for subnet 1"
  type        = string
}

variable "subnet2_cidr" {
  description = "CIDR block for subnet 2"
  type        = string
}

variable "subnet3_cidr" {
  description = "CIDR block for subnet 3"
  type        = string
}
#
variable "subnet4_cidr" {
  description = "CIDR block for subnet 4"
  type        = string
}

variable "subnet5_cidr" {
  description = "CIDR block for subnet 5"
  type        = string
}

# variables.tf
variable "number_of_public_subnets" {
  description = "Number of public subnets"
  type        = number
}

variable "number_of_private_subnets" {
  description = "Number of private subnets"
  type        = number
}

variable "number_of_secure_subnets" {
  description = "Number of secure subnets"
  type        = number
}
#
# variable "subnet6_cidr" {
#   description = "CIDR block for subnet 6"
#   type        = string
# }

