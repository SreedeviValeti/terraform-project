#Secret For RDS Database Instance 
/*resource "aws_secretsmanager_secret" "rds_secret" {
  depends_on = [random_password.rds_password_random]
  name = "${var.env}-rds-secret"
}

#Secret Value and Secret Association"
resource "aws_secretsmanager_secret_version" "rds_secret_version" {
depends_on = [aws_secretsmanager_secret.rds_secret]
  secret_id = aws_secretsmanager_secret.rds_secret.id
  secret_string = random_password.rds_password_random.result
}

#Secret Value
resource "random_password" "rds_password_random" {
  length = 15
}
#RDS Instance
resource "aws_db_instance" "rds_instance" {
 depends_on =[ aws_secretsmanager_secret_version.rds_secret_version]
  allocated_storage    = 10
  db_name              = "devdb"
  engine               = "mysql"
  engine_version       = "8.0"
  identifier           = "${var.env}-rds-instance"
  instance_class       = "db.t3.micro"
  username             = "devdb_admin"
  db_subnet_group_name = "
  password             = aws_secretsmanager_secret_version.rds_secret_version.secret_string
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}
#RDS Subnet Group
resource "aws_db_subnet_group" "subnet_group"{
  name = "subnet_group"
  subnet_ids = [aws_subnet_group.public_subnet1.id, aws_subnet_group.public_subnet2.id]
  tags = {
    name = ${var.env}-subnet_group
  }
}*/
