resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "16.4"
  instance_class       = "db.t3.micro"
  db_name              = "shopsmartdb"
  username             = "ssadmin"
  password             = "abcd1234"
  # parameter_group_name = "default.postgres13"
  skip_final_snapshot  = true
  publicly_accessible  = true
  # vpc_security_group_ids = [module.vpc.default_security_group_id]
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.default.name

  tags = {
    Name = "MyPostgresDB"
  }
}

# resource "null_resource" "create_additional_databases" {
#   provisioner "local-exec" {
#     command = <<EOT
#       PGPASSWORD=abcd1234 psql -h ${aws_db_instance.postgres.address} -U admin -d postgres -c "CREATE DATABASE merchant;"
#       PGPASSWORD=abcd1234 psql -h ${aws_db_instance.postgres.address} -U admin -d postgres -c "CREATE DATABASE customer;"
#     EOT
#   }
# }

resource "aws_db_subnet_group" "default" {
  name       = "postgres-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "PostgresSubnetGroup"
  }
}

# resource "aws_route53_record" "rds_cname" {
#   zone_id = var.zone_id
#   name    = "postgres.ss.aws.com"
#   type    = "CNAME"
#   ttl     = 300
#   records = [aws_db_instance.postgres.endpoint]
# }