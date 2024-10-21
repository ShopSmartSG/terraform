output "postgres_endpoint" {
  description = "The endpoint of the RDS Postgres instance"
  value       = aws_db_instance.postgres.endpoint
}