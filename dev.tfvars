region = "us-east-2"
vpc_cidr = "172.30.0.0/16"
public_subnet_cidr = ["172.30.1.0/24","172.30.2.0/24"]
public_subnet_az = ["us-east-2a","us-east-2b"]
instance_type = "t2.nano"
env = "dev"
keyname = "ohio"
web_sg_ingress = [
{
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0" ]
},
{
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0" ]
}
]
