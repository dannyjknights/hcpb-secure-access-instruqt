output "rds_endpoint" {
  value = aws_db_instance.boundary_demo.domain_fqdn
}