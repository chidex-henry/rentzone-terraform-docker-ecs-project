# create database subnet group
resource "aws_db_subnet_group" "database_subnet_group" {
  name        = "${var.project_name}-${var.environment}-db-subnet"
  subnet_ids  = [aws_subnet.private_data_subnet_az1.id, aws_subnet.private_data_subnet_az2.id ]
  description = "subnets for database instance"

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet"
  }
}

# create the rds instance
resource "aws_db_instance" "database_instance" {
  engine                 = "mysql"
  engine_version         = "8.0.33"
  multi_az               = var.multi_az_deployment
  identifier             = var.database_instance_identifier
  username               = "chidex"
  password               = var.database_password
  db_name                = "applicationdb"
  instance_class         = var.database_instance_class
  allocated_storage      = 200
  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.id
  vpc_security_group_ids = [aws_security_group.database_security_group.id]
  availability_zone      = data.aws_availability_zones.available_zones.names[1]
  skip_final_snapshot    = true
  publicly_accessible    = var.publicly_accessible
}

 