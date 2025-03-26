variable "region" {
    type = string
}

variable "vpc_cidr" {
    type = string
}

variable "public_subnet_cidr" {
}

variable "public_subnet_az" {
}

variable "instance_type" {
   type = string
}

variable "env" {}

variable "keyname" {}


variable "web_sg_ingress_rule" {}

