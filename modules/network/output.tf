output "virtualnetwork_id" {
  description = "The ID of the virtual network."
  value       = azurerm_virtual_network.virtualnetwork.id
}

output "virtualnetwork_name" {
  description = "The name of the virtual network."
  value       = azurerm_virtual_network.virtualnetwork.name
}

output "subnet_agw_id" {
  description = "The ID of the Application Gateway subnet."
  value       = azurerm_subnet.subnets["agw"].id
}

output "subnet_pe_id" {
  description = "The ID of the Private Endpoint subnet."
  value       = azurerm_subnet.subnets["pe"].id
}

output "subnet_db_id" {
  description = "The ID of the Database subnet."
  value       = azurerm_subnet.subnets["db"].id
}

output "subnet_app_id" {
  description = "The ID of the Application/Backend subnet."
  value       = azurerm_subnet.subnets["app"].id
}

output "private_dns_zone_id" {
  description = "The ID of the private DNS zone for PostgreSQL."
  value       = azurerm_private_dns_zone.postgres.id
}

