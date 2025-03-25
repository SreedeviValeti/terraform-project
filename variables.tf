variable "region" {
    type = string
}

variable "vpc_cidr" {
    type = string
}

variable "public_subnet_cidr" {
    type = map(string)
    default = {
     dev = "172.30.1.0/24"
     uat = "172.30.2.0/24"
     prd = "172.30.3.0/24"
    }
}

variable "public_subnet_az" {
    type = list(string)
    default = ["us-east-2a", "us-east-2b"]
}

variable "instance_type" {
   type = map(string)
   default = {
    dev = "t2.nano"
    uat = "t2.nano"
    prd = "t2.micro"
   }
}

