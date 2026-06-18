output "static_site_id" {
  description = "The resource ID of the Static Web App"
  value       = azurerm_static_web_app.Quantumems-static-app.id
}

output "default_host_name" {
  description = "Default hostname of the SWA (e.g., xxxxxxx.azurestaticapps.net)"
  value       = azurerm_static_web_app.Quantumems-static-app.default_host_name
}

output "api_key" {
  description = "Deployment API key for the SWA — add this as a GitHub Actions secret (AZURE_STATIC_WEB_APPS_API_TOKEN)"
  value       = azurerm_static_web_app.Quantumems-static-app.api_key
  sensitive   = true
}
