output "storage_account_name" {
  description = "Name of the Storage Account."
  value       = azurerm_storage_account.this.name
}

output "storage_account_id" {
  description = "Resource ID of the Storage Account."
  value       = azurerm_storage_account.this.id
}

output "primary_blob_endpoint" {
  description = "The private blob service endpoint URL (accessed via Private Endpoint inside the VNet)."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "primary_access_key" {
  description = "The primary access key for the Storage Account (sensitive — use for App Service env var)."
  value       = azurerm_storage_account.this.primary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  description = "Full connection string for the Storage Account (sensitive)."
  value       = azurerm_storage_account.this.primary_connection_string
  sensitive   = true
}

output "profile_images_container_name" {
  description = "Name of the blob container for profile images."
  value       = azurerm_storage_container.profile_images.name
}

output "documents_container_name" {
  description = "Name of the blob container for employee documents and PDFs."
  value       = azurerm_storage_container.documents.name
}

output "employees_container_name" {
  description = "Name of the blob container used by the backend app (hardcoded as 'employees')."
  value       = azurerm_storage_container.employees.name
}
