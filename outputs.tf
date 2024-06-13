output "rds_endpoint_address" {
  value = aws_db_instance.boundary_demo.address
}

output "rds_endpoint_domain_fqdn" {
  value = aws_db_instance.boundary_demo.domain_fqdn
}

output "rds_endpoint_endpoint" {
  value = aws_db_instance.boundary_demo.endpoint
}