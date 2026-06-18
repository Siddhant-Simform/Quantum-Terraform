resource "azurerm_postgresql_flexible_server" "postgresqldbsvr" {
  name                   = var.postgresqldb_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = var.pg_version
  administrator_login    = var.admin_username
  administrator_password = var.admin_password

  # Private networking via subnet delegation
  delegated_subnet_id = var.subnet_id
  private_dns_zone_id = var.dns_zone_id

  # Storage
  storage_mb = var.storage_mb

  sku_name                      = var.sku_name
  public_network_access_enabled = var.public_network_access_enabled

  # Backup
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  tags = var.tags

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      zone,
    ]
  }
}
