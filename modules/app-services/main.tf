# ─── App Service Plan ─────────────────────────────────────────────────────────

resource "azurerm_service_plan" "this" {
  name                = var.app_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.os_type
  sku_name            = var.app_service_sku_name
  tags                = var.tags
}

# ─── Linux Web App (Backend — Docker container from ACR) ──────────────────────

resource "azurerm_linux_web_app" "this" {
  name                      = var.app_name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  service_plan_id           = azurerm_service_plan.this.id
  virtual_network_subnet_id = var.subnet_id
  https_only                = var.https_only
  tags                      = var.tags

  # ── System-Assigned Managed Identity ─────────────────────────────────────
  # Grants the app an identity in Azure AD so it can be granted access
  # to Key Vault, ACR (via role assignment), etc.
  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on                         = var.always_on
    minimum_tls_version               = var.minimum_tls_version
    health_check_path                 = "/health"
    health_check_eviction_time_in_min = 5

    # ── Docker container pulled from ACR ──────────────────────────────────
    application_stack {
      docker_image_name        = var.docker_image_name
      docker_registry_url      = var.docker_registry_url
      docker_registry_username = var.docker_registry_username
      docker_registry_password = var.docker_registry_password
    }

    # ── CORS ──────────────────────────────────────────────────────────────
    # dynamic block: only created when cors_allowed_origins is non-empty.
    # This avoids the AzureRM provider bug where a computed (unknown-at-plan)
    # origin list causes "block count changed from 0 to 1" at apply time.
    dynamic "cors" {
      for_each = length(var.cors_allowed_origins) > 0 ? [1] : []
      content {
        allowed_origins     = var.cors_allowed_origins
        support_credentials = var.cors_support_credentials
      }
    }
  }

  # ── Runtime environment variables ─────────────────────────────────────────
  app_settings = var.app_settings

  # ── HTTP log retention (file system) ──────────────────────────────────────
  logs {
    http_logs {
      file_system {
        retention_in_days = var.log_retention_days
        retention_in_mb   = 35
      }
    }
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.this.identity[0].principal_id
}
