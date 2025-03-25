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

# Subnet 1
resource "aws_subnet" "public_subnet1" {
  cidr_block        = var.public_subnet_cidr[1]
  availability_zone = var.public_subnet_az[1]
  vpc_id            = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-public_subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  cidr_block        = var.public_subnet_cidr[0]
  availability_zone = var.public_subnet_az[0]
  vpc_id            = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-public_subnet2"
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
    Name = "${var.env}-public_route_table"
  }
}

#Route Table Association
resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
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

data aws_ami "webserver_ami" {
  filter {
    name = "image-id"
    values = ["ami-04f167a56786e4b09"]
}
}

#Public Webserver
resource aws_instance "public_webserver" {
  ami = data.aws_ami.webserver_ami.id
  associate_public_ip_address = true
  instance_type = var.instance_type 
  key_name = "ohio"
  security_groups = ["${aws_security_group.vpc_sg.id}"]
  subnet_id = aws_subnet.public_subnet.id
  tags = {
    Name = "${var.env}-webserver"
  }
  user_data = <<EOF
#!/bin/bash
sudo su -
sudo apt-get update -y
sudo apt-get install apache2 -y 
sudo systemctl start apache2
sudo systemctl enable apache2
echo "This apache server is in ${var.env} deployed by terraform" >/var/www/html/index.html
EOF

}
#S3 Bucket
resource aws_s3_bucket "webserver_bucket" {
   bucket = "${var.env}-webserver-logs-bucket"

   tags = {
    name = "${var.env}-webserver-logs-bucket"
   }
   depends_on = [aws_instance.public_webserver]
}

