resource "null_resource" "null_resource" {
count = length(var.public_subnet_cidr)
 connection {
 type = "ssh"
 user = "ec2-user"
 privatekey = file("erpa-practice-key.pem") 
 host = element(aws_instance.public_instance.[*].public_ip, count.index)
 }
 provisioner "file" {
 source = "userdata.sh"
 destination = "/etc/rc.d/userdata.sh"
 }
 provisioner "remote-exec" {
 inline = [
 "chmod +x /etc/rc.d/userdata.sh"
 sudo /etc/rc.d/userdata.sh
 ]
 }
}
