# ─── Storage Account ──────────────────────────────────────────────────────────
# Private-access storage for EMS profile images and document/PDF uploads.
# Public blob access is disabled; the App Service reaches the account via a
# Private Endpoint placed in subnet-pe.

resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  account_kind             = "StorageV2"

  # ── Security hardening ────────────────────────────────────────────────────
  min_tls_version = "TLS1_2"

  # Disable ALL public blob access — only Private Endpoint traffic is allowed
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = true

  # ── Blob properties ───────────────────────────────────────────────────────
  blob_properties {
    # Soft-delete keeps blobs recoverable for N days after accidental deletion
    delete_retention_policy {
      days = var.blob_soft_delete_days
    }
    # Versioning lets you restore previous file versions (profile pics, docs)
    versioning_enabled = var.blob_versioning_enabled
  }

  # ── Network rules ─────────────────────────────────────────────────────────
  # Default: deny all. Access is only permitted via Private Endpoint.
  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    virtual_network_subnet_ids = var.allowed_subnet_ids
  }

  tags = var.tags
}

# ─── Blob Containers ──────────────────────────────────────────────────────────

resource "azurerm_storage_container" "profile_images" {
  name                  = "profile-images"
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private" # No anonymous public read
}

resource "azurerm_storage_container" "documents" {
  name                  = "documents"
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private" # No anonymous public read
}

# The backend app initialises Blob Storage with container name "employees"
# (see: 🔌 Azure Blob Storage client initialized. Container: "employees")
# This container holds the same data — employee profile images & documents.
resource "azurerm_storage_container" "employees" {
  name                  = "employees"
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private" # No anonymous public read
}

# ─── Private DNS Zone for Blob ────────────────────────────────────────────────
# Allows VNet-integrated resources (App Service) to resolve the storage account
# using its private IP instead of the public endpoint.

resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                  = "${var.storage_account_name}-blob-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = false
  tags                  = var.tags
}

# ─── Private Endpoint ─────────────────────────────────────────────────────────
# Places a private NIC for the storage account inside subnet-pe.
# Traffic from the App Service (subnet-app, VNet integrated) flows directly
# to this NIC — never leaving the VNet.

resource "azurerm_private_endpoint" "blob" {
  name                = "${var.storage_account_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "${var.storage_account_name}-psc"
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "blob-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }
}
