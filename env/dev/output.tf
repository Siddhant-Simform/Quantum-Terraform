output "name" {
  description = "The name of the PostgreSQL Flexible Server."
  value       = { for k, v in module.quantumems-dev-postgresqldbsvr-cin : k => v.name }
}

output "swa_deploy_token" {
  description = "GitHub Actions deployment token for the SWA — add as AZURE_STATIC_WEB_APPS_API_TOKEN secret"
  value       = { for k, v in module.quantumems-dev-static-app-cin : k => v.api_key }
  sensitive   = true
}

output "swa_host_name" {
  description = "Default hostname of the SWA (use this for cors_allowed_origins in tfvars)"
  value       = { for k, v in module.quantumems-dev-static-app-cin : k => v.default_host_name }
}

output "acr_login_server" {
  description = "ACR login server URL — use this as the registry when running docker push"
  value       = { for k, v in module.quantumems-acr : k => v.login_server }
}

output "app_service_hostname" {
  description = "Default hostname of the App Service (backend)"
  value       = { for k, v in module.quantumems-app-services : k => v.default_hostname }
}

output "storage_account_name" {
  description = "Name of the Storage Account created for EMS profile images and documents."
  value       = { for k, v in module.quantumems-storage : k => v.storage_account_name }
}

output "storage_primary_blob_endpoint" {
  description = "Private blob endpoint URL (accessible only from within the VNet)."
  value       = { for k, v in module.quantumems-storage : k => v.primary_blob_endpoint }
}
