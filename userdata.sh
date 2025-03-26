#!bin/bash
sudo su -
sudo yum install -y amazon-ssm-agent
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
sudo systemctl status amazon-ssm-agent
sudo yum install -y unzip curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version  # Verify installation
yum install nginx -y
systemctl start nginx
systemctl enable nginx
systemctl restart nginx
echo "Wecome to nginx server deployed by terraform" > /var/www/html/index.html
