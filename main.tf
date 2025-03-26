# Configure AWS Provider
provider "aws" {
  region = var.region
  default_tags {
    tags = {
      provider    = "aws"
      deployed_by = "terraform"
    }
  }

}

# VPC
resource "aws_vpc" "vpc" {
  enable_dns_support   = true
  enable_dns_hostnames = true
  cidr_block           = var.vpc_cidr
  tags = {
    Name = "vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "internet-gateway"
  }
}

# Public Subnet 
resource "aws_subnet" "public_subnet" {
  count =2
  cidr_block        = element(var.public_subnet_cidr, count.index)
  availability_zone = element(var.public_subnet_az, count.index)
  vpc_id            = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-public_subnet-${count.index}"
  }
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
  count =2 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-public_route_table-${count.index}"
  }
}

#Route Table Association
resource "aws_route_table_association" "public-rt-association" {
  count = 2
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = element(aws_route_table.public_route_table[*].id, count.index)
}

# VPC Security group
resource "aws_security_group" "vpc_sg" {
  name   = "${var.env}-vpc_sg"
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "vpc-sg"
  }
}

# VPC Security group Ingress Rule
resource "aws_vpc_security_group_ingress_rule" "ingress_allow_tcp_http" {
  security_group_id = aws_security_group.vpc_sg.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

# VPC Security group Egress Rule
resource "aws_vpc_security_group_egress_rule" "egress_allow_tcp_http" {
  security_group_id = aws_security_group.vpc_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}



