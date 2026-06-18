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
  public_network_access_enabled = false

  tags = var.tags
}

resource "azurerm_role_assignment" "keyvault_role" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = var.role_definition_name
  principal_id         = var.principal_id != "" ? var.principal_id : data.azurerm_client_config.current.object_id
}

# ─── Private DNS Zone for Key Vault ──────────────────────────────────────────
resource "azurerm_private_dns_zone" "vault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "vault" {
  name                  = "${var.keyvault_name}-vault-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.vault.name
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = false
  tags                  = var.tags
}

# ─── Private Endpoint for Key Vault ──────────────────────────────────────────
resource "azurerm_private_endpoint" "vault" {
  name                = "${var.keyvault_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "${var.keyvault_name}-psc"
    private_connection_resource_id = azurerm_key_vault.keyvault.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "vault-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.vault.id]
  }
}


