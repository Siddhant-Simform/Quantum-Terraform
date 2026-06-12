output "name" {
  description = "The name of the PostgreSQL Flexible Server."
  value       = module.quantumems-dev-postgresqldbsvr-cin.name
}

output "subnet_id" {
  description = "The ID of the database subnet."
  value       = module.quantumems-dev-network-cin.subnet_db_id
}