resource "aws_db_instance" "default" {
  allocated_storage           = 10
  identifier                  = "book-rds"
  db_name                     = "mydb"
  engine                      = "mysql"
  engine_version              = "8.0"
  instance_class              = "db.t3.micro"
  manage_master_user_password = true #rds and secret manager manage this password
  username                    = "admin"
  db_subnet_group_name        = aws_db_subnet_group.mysql_subnet_group.id
  parameter_group_name        = "default.mysql8.0"
  backup_retention_period     = 7             # Retain backups for 7 days
  backup_window               = "02:00-03:00" # Daily backup window (UTC)

  # Enable performance insights
  #   performance_insights_enabled          = true
  #   performance_insights_retention_period = 7  # Retain insights for 7 days
  maintenance_window  = "sun:04:00-sun:05:00" # Maintenance every Sunday (UTC)
  deletion_protection = false
  skip_final_snapshot = true
  depends_on          = [aws_db_subnet_group.mysql_subnet_group]

}

# -----------------------------
# 1️⃣ Create DB Subnet Group
# -----------------------------
resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "mysql-subnet-group1"
  subnet_ids = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id] # replace with your subnet IDs

  tags = {
    Name = "mysql-subnet-group2"
  }
}

data "aws_subnet" "subnet1" {

  filter {
    name   = "tag:Name"
    values = ["subnet1"]
  }

}

data "aws_subnet" "subnet2" {

  filter {
    name   = "tag:Name"
    values = ["subnet2"]
  }

}

# -----------------------------
# Create RDS Read Replica
# -----------------------------
resource "aws_db_instance" "read_replicaaaa" {
  identifier           = "book-rds-replica"
  replicate_source_db  = aws_db_instance.default.arn
  instance_class       = "db.t3.micro"
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.mysql_subnet_group.name
  skip_final_snapshot  = true
  depends_on           = [aws_db_instance.default]

  tags = {
    Name = "book-rds-replica"
  }
}