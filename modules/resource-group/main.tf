resource "azurerm_resource_group" "quantumems-rg" {
  name     = var.name
  location = var.location
  tags     = var.tags
}