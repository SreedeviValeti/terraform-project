output "vpc_id" {
    value = aws_vpc.vpc.id
}

output "ig_id" {
    value = aws_internet_gateway.internet-gateway.id
}

output "security_group_id" {
    value = aws_security_group.vpc_sg.id
}
output "publicsubnet_id" {
  value = aws_subnet.public_subnet[*].id
}
