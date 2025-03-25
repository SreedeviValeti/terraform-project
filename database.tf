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
