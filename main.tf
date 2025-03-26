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
count = 1
  cidr_block        = element(var.public_subnet_cidr, count.index + 1)
  availability_zone = element(var.public_subnet_az, count.index + 1)
  vpc_id            = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-public_subnet-${count.index + 1}"
  }
}

# Private Subnet 
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidr)
  cidr_block        = element(var.private_cidr, count.index + 1)
  availability_zone = element(var.private_az, count.index + 1)
  vpc_id            = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-private_subnet-${count.index + 1}"
  }
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-public_route_table"
  }
}
# Private Route Table
resource "aws_route_table" "private_route_table" {
  route {
    cidr_block = var.vpc_cidr
    gateway_id = aws_nat_gateway.nat_gateway.id
  }
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-private_route_table"
  }
}

#Nat Gateway
resource "aws_nat_gateway" "nat_gateway" {
allocation_id = aws_eip.eip.id
subnet_id = aws_subnet.public_subnet.[0]
tags = {
name = "vpc-nat-gateway"
}

#EIP
resource "aws_eip" "eip" {
domain       = "vpc"
}

}
#Route Table Association
resource "aws_route_table_association" "public-rt-association" {
  count = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = element(aws_route_table.public_route_table[*].id, count.index)
}
#Private Route Table Association
resource "aws_route_table_association" "private-rt-association" {
  count = length(var.private_subnet_cidr)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
  route_table_id = element(aws_route_table.private_route_table[*].id, count.index)
}

# VPC Security group
resource "aws_security_group" "web_sg" {
  name   = "${var.env}-web-_sg"
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-web-_sg"
  }
}

#VPC Security group ingress rule
resource "aws_security_group_rule" "web_sg_ingress" {
 for_each = {for idx, rule in var.web_sg_ingress_rule : idx => rule}
  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.web_sg.id
}

#VPC Security group egress rule
resource "aws_security_group_rule" "web_sg_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}





