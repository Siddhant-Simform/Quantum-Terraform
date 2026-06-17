resource "azurerm_static_web_app" "Quantumems-static-app" {
  name                = var.app_name
  resource_group_name = var.resource_group_name
  location            = var.swa_location
  sku_tier            = var.sku_tier
  sku_size            = var.sku_size 
  tags                = var.tags
}

