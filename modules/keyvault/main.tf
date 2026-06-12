data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                        = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = var.sku_name
  enabled_for_disk_encryption = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  rbac_authorization_enabled  = var.rbac_authorization_enabled

  tags = var.tags
}

resource "azurerm_role_assignment" "keyvault_role" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = var.role_definition_name
  principal_id         = var.principal_id != "" ? var.principal_id : data.azurerm_client_config.current.object_id
}

