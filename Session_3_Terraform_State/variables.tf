variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

# terraform/variables.tf
variable "prefix" {
  description = "Prefix for resource names"
  type        = string
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

variable "subnet4_cidr" {
  description = "CIDR block for subnet 4"
  type        = string
}

variable "subnet5_cidr" {
  description = "CIDR block for subnet 5"
  type        = string
}

variable "subnet6_cidr" {
  description = "CIDR block for subnet 6"
  type        = string
}

