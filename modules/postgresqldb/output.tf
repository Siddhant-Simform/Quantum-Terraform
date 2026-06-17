output "name" {
  description = "The name of the PostgreSQL Flexible Server."
  value       = azurerm_postgresql_flexible_server.postgresqldbsvr.name
}

output "fqdn" {
  description = "The FQDN of the PostgreSQL Flexible Server (private DNS resolution within VNet)."
  value       = azurerm_postgresql_flexible_server.postgresqldbsvr.fqdn
}