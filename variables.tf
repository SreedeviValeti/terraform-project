variable "region" {
    type = string
}

variable "vpc_cidr" {
    type = string
}

variable "public_subnet_cidr" {
    type = string
}

variable "public_subnet_az" {
    type = string
}

variable "instance_type" {
   type = string
}

variable "env" {}

variable "keyname" {}


variable "web_sg_ingress_rule" {}

