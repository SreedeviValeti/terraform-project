#Secret For RDS Database Instance 
resource "aws_secretsmanager_secret" "${var.env}_rds_secret" {
  name = "${var.env}-rds-secret"
}

#Secret Value and Secret Association"
resource "aws_secretsmanager_secret_version"  "${var.env}_rds_secret_version" {
  secret_id = aws_secretsmanager_secret.${var.env}_rds_secret.id
  secret_string = random_password.${var.env}_rds_password_random.result
}

#Secret Value
resource "random_password" "${var.env}_rds_password_random" {
  length = 15
}

resource "aws_db_instance" "${var.env}_rds_instance" {
  allocated_storage    = 10
  db_name              = "devdb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "devdb_admin"
  db_subnet_group_name = "
  password             = aws_secretsmanager_secret_version.${var.env}_rds_secret_version.secret_string
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}

resource "aws_db_subnet_group" "${var.env}_subnet_group"{
  name = "${var.env}_subnet_group"
  subnet_ids = []
  tags = {
    name = ${var.env}_subnet_group
  }
}
