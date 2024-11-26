resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.qian-vpc.id
  cidr_block        = var.subnet1_cidr
  availability_zone = "eu-central-1a"

  tags = {
    Name = format("%s-public-subnet-1", var.prefix)
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.qian-vpc.id
  cidr_block        = var.subnet2_cidr
  availability_zone = "eu-central-1a"

  tags = {
    Name = format("%s-private-subnet-1", var.prefix)
  }
}

resource "aws_subnet" "secure_subnet_1" {
  vpc_id            = aws_vpc.qian-vpc.id
  cidr_block        = var.subnet3_cidr
  availability_zone = "eu-central-1a"

  tags = {
    Name = format("%s-secure-subnet-1", var.prefix)
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.qian-vpc.id
  cidr_block        = var.subnet4_cidr
  availability_zone = "eu-central-1b"

  tags = {
    Name = format("%s-public-subnet-2", var.prefix)
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.qian-vpc.id
  cidr_block        = var.subnet5_cidr
  availability_zone = "eu-central-1b"

  tags = {
    Name = format("%s-private-subnet-2", var.prefix)
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.qian-vpc.id

  tags = {
    Name = "qian-iac-lab-gw"
  }
}


resource "aws_eip" "bar" {
  domain = "vpc"

  depends_on                = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.bar.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}


locals {
  public_subnets = [
    aws_subnet.public_subnet_1,
    aws_subnet.public_subnet_2
  ]
  private_subnets = [
    aws_subnet.private_subnet_1,
    aws_subnet.private_subnet_2
  ]
}

output "public_subnets" {
  value = local.public_subnets
}

output "private_subnets" {
  value = local.private_subnets
}
