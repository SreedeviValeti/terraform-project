# Configure AWS Provider
provider "aws" {
  region = "us-east-2"
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
  cidr_block           = "172.30.0.0/16"
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

# Subnet
resource "aws_subnet" "public_subnet" {
  cidr_block        = "172.30.0.0/24"
  availability_zone = "us-east-2a"
  vpc_id            = aws_vpc.vpc.id
  tags = {
    Name = "public_subnet"
  }
}

#Route Table
resource "aws_route_table" "public_route_table" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "public_route_table"
  }
}

#Route Table Association
resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# VPC Security group
resource "aws_security_group" "vpc_sg" {
  name   = "vpc_sg"
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
  cidr_ipv4         = "172.30.0.0/24"
}

# VPC Security group Egress Rule
resource "aws_vpc_security_group_egress_rule" "egress_allow_tcp_http" {
  security_group_id = aws_security_group.vpc_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}
