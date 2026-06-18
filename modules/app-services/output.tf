output "app_service_id" {
  description = "Resource ID of the Linux Web App."
  value       = azurerm_linux_web_app.this.id
}

output "app_service_name" {
  description = "Name of the Linux Web App."
  value       = azurerm_linux_web_app.this.name
}

output "default_hostname" {
  description = "Default HTTPS hostname of the Web App (e.g. myapp.azurewebsites.net)."
  value       = azurerm_linux_web_app.this.default_hostname
}

output "principal_id" {
  description = "Object ID of the System-Assigned Managed Identity (for Key Vault / ACR role assignments)."
  value       = azurerm_linux_web_app.this.identity[0].principal_id
}
