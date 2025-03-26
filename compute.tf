/*data aws_ami "webserver_ami" {
  filter {
    name = "image-id"
    values = ["ami-04f167a56786e4b09"]
}
}

#Public Webserver

resource aws_instance "public_webserver" {
  count = var.env == "dev" ? 1 :0
  ami = data.aws_ami.webserver_ami.id
  associate_public_ip_address = true
  instance_type = var.instance_type 
  key_name = var.keyname
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
}*/
