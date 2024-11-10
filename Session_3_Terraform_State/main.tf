resource "aws_vpc" "qian-vpc" {
  cidr_block = "10.0.0.0/18"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "demo"
  }
}



