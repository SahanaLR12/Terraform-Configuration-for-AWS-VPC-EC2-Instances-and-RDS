# Create the RDS instance
resource "aws_db_instance" "example" {
  identifier        = "example-db"
  engine            = "mysql"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"
  db_name           = "exampledb"
  username          = "admin"
  password          = ""  # Change this to a secure password
  parameter_group_name = "default.mysql8.0"
  db_subnet_group_name = aws_db_subnet_group.example.name/*aws_db_subnet_group.example.name*/
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  multi_az          = false
  publicly_accessible = false
  skip_final_snapshot = true
  tags = {
    Name = "example-db-instance"
  }
}