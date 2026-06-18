output "login_server" {
  description = "The login server URL of the ACR (e.g., acrname.azurecr.io)"
  value       = azurerm_container_registry.this.login_server
}

output "acr_id" {
  description = "The resource ID of the ACR"
  value       = azurerm_container_registry.this.id
}

output "acr_name" {
  description = "The name of the ACR"
  value       = azurerm_container_registry.this.name
}

output "admin_username" {
  description = "ACR admin username (used by App Service to pull images)"
  value       = azurerm_container_registry.this.admin_username
  sensitive   = true
}

output "admin_password" {
  description = "ACR admin password (used by App Service to pull images)"
  value       = azurerm_container_registry.this.admin_password
  sensitive   = true
}
