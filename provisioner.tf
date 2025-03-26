resource "null_resource" "null_resource" {
 connection {
 type = "ssh"
 user = "ec2-user"
 privatekey = file("erpa-practice-key.pem")
 host = aws_instance.public_instance.[*].public_ip
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
