module "quantumems-dev-rg-cin" {
  for_each = var.resource_groups
  source   = "../../modules/resource-group"
  name     = each.value.rg_name
  location = each.value.location
  tags     = var.tags
}

module "quantumems-dev-network-cin" {
  for_each            = var.resource_groups
  source              = "../../modules/network"
  resource_group_name = module.quantumems-dev-rg-cin[each.key].rg_name
  location            = module.quantumems-dev-rg-cin[each.key].location
  tags                = var.tags

  virtualnetwork_name = each.value.network.vnet_name
  address_space       = each.value.network.address_space
  subnets             = each.value.network.subnets
  nsg_db_name         = each.value.network.nsg_db_name
}

module "quantumems-dev-postgresqldbsvr-cin" {
  for_each            = var.resource_groups
  source              = "../../modules/postgresqldb"
  resource_group_name = module.quantumems-dev-rg-cin[each.key].rg_name
  postgresqldb_name   = "quantumems-${each.key}-pg-cin"
  location            = module.quantumems-dev-rg-cin[each.key].location
  tags                = var.tags
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  sku_name            = var.sku_name
  storage_mb          = var.storage_mb
  pg_version          = var.pg_version
  subnet_id           = module.quantumems-dev-network-cin[each.key].subnet_db_id
  dns_zone_id         = module.quantumems-dev-network-cin[each.key].private_dns_zone_id
}

module "quantumems-dev-keyvault-cin" {
  for_each            = var.resource_groups
  source              = "../../modules/keyvault"
  resource_group_name = module.quantumems-dev-rg-cin[each.key].rg_name
  location            = module.quantumems-dev-rg-cin[each.key].location
  tags                = var.tags
  keyvault_name       = "quantumems-${each.key}-kv-cin"
  sku_name            = "standard"
}

module "quantumems-dev-static-app-cin" {
  for_each            = var.resource_groups
  source              = "../../modules/static-apps"
  resource_group_name = module.quantumems-dev-rg-cin[each.key].rg_name
  swa_location        = var.swa_location
  tags                = var.tags
  app_name            = "${var.swa_app_name}-${each.key}"
  repository_url      = var.repository_url
  branch              = var.branch
}

module "quantumems-acr" {
  for_each            = var.resource_groups
  source              = "../../modules/acr"
  resource_group_name = module.quantumems-dev-rg-cin[each.key].rg_name
  location            = module.quantumems-dev-rg-cin[each.key].location
  tags                = var.tags
  acr_name            = "quantumemsacr${each.key}cin"
  acr_sku             = var.acr_sku
}

module "quantumems-storage" {
  for_each            = var.resource_groups
  source              = "../../modules/storage-account"
  resource_group_name = module.quantumems-dev-rg-cin[each.key].rg_name
  location            = module.quantumems-dev-rg-cin[each.key].location
  tags                = var.tags

  # ── Naming ────────────────────────────────────────────────────────────────
  # Storage account names: 3-24 chars, lowercase alphanumeric only, globally unique
  storage_account_name = "qemssa${each.key}cin"

  # ── SKU ───────────────────────────────────────────────────────────────────
  account_tier     = var.storage_account_tier
  replication_type = var.storage_replication_type

  # ── Blob settings ─────────────────────────────────────────────────────────
  blob_soft_delete_days   = var.storage_blob_soft_delete_days
  blob_versioning_enabled = var.storage_blob_versioning_enabled

  # ── Networking ────────────────────────────────────────────────────────────
  # VNet ID is needed to link the Private DNS Zone for blob resolution
  virtual_network_id = module.quantumems-dev-network-cin[each.key].virtualnetwork_id
  # Private Endpoint NIC is placed in subnet-pe
  private_endpoint_subnet_id = module.quantumems-dev-network-cin[each.key].subnet_pe_id
}

module "quantumems-app-services" {
  for_each            = var.resource_groups
  source              = "../../modules/app-services"
  resource_group_name = module.quantumems-dev-rg-cin[each.key].rg_name
  location            = module.quantumems-dev-rg-cin[each.key].location
  tags                = var.tags

  # ── Naming ────────────────────────────────────────────────────────────────
  app_plan_name = "${var.app_plan_name}-${each.key}"
  app_name      = "${var.app_service_name}-${each.key}"

  # ── Plan / SKU ────────────────────────────────────────────────────────────
  app_service_sku_name = var.app_service_sku_name
  os_type              = var.app_os_type

  # ── Networking ────────────────────────────────────────────────────────────
  subnet_id = module.quantumems-dev-network-cin[each.key].subnet_app_id

  # ── ACR — resource ID for the AcrPull role assignment ────────────────────
  acr_id = module.quantumems-acr[each.key].acr_id

  # ── Docker image from ACR ─────────────────────────────────────────────────
  # Registry URL and credentials are read from ACR module outputs —
  # no manual copy-paste of secrets required.
  docker_image_name        = var.docker_image_name
  docker_registry_url      = "https://${module.quantumems-acr[each.key].login_server}"
  docker_registry_username = module.quantumems-acr[each.key].admin_username
  docker_registry_password = module.quantumems-acr[each.key].admin_password

  # ── Site Config ───────────────────────────────────────────────────────────
  always_on           = var.app_always_on
  https_only          = var.app_https_only
  minimum_tls_version = var.app_minimum_tls_version
  log_retention_days  = var.app_log_retention_days

  # ── CORS ──────────────────────────────────────────────────────────────────
  # Use a static list from tfvars instead of a computed SWA output.
  # Computed outputs are unknown at plan time and trigger the AzureRM provider
  # bug: "block count changed from 0 to 1".
  # After first apply: copy the SWA hostname into cors_allowed_origins in tfvars.
  cors_allowed_origins     = var.cors_allowed_origins
  cors_support_credentials = var.cors_support_credentials

  # ── App Settings (runtime environment variables) ──────────────────────────
  # Four-way merge (later maps win on key collision):
  #   1. var.app_settings            → non-sensitive values from terraform.tfvars
  #   2. var.sensitive_app_settings  → JWT_SECRET etc. from secrets.tfvars
  #   3. DB + Storage module outputs → auto-sourced, no hardcoding
  #
  # db.js reads individual DB_* env vars (NOT a DATABASE_URL connection string).
  # DB_HOST is sourced from the PostgreSQL module's `fqdn` output so it is
  # always correct without any manual copy-paste.
  app_settings = merge(
    var.app_settings,
    var.sensitive_app_settings,
    {
      # ── Database (individual vars read by db.js) ──────────────────────────────
      # FQDN resolves to a private IP via Private DNS Zone — only reachable
      # from within the VNet (App Service reaches it via VNet Integration).
      DB_HOST     = module.quantumems-dev-postgresqldbsvr-cin[each.key].fqdn
      DB_USER     = var.admin_username
      DB_PASSWORD = var.admin_password
      DB_NAME     = "postgres"
      DB_PORT     = "5432"
      DB_SSL      = "true"

      # ── Storage ─────────────────────────────────────────────────────────────
      AZURE_STORAGE_CONNECTION_STRING = module.quantumems-storage[each.key].primary_connection_string
      AZURE_STORAGE_ACCOUNT_NAME      = module.quantumems-storage[each.key].storage_account_name

      # Container the backend app uses (hardcoded as 'employees' in server.js)
      AZURE_STORAGE_CONTAINER_NAME     = module.quantumems-storage[each.key].employees_container_name

      # Additional named containers for future use (profile images, documents)
      AZURE_STORAGE_CONTAINER_PROFILES = module.quantumems-storage[each.key].profile_images_container_name
      AZURE_STORAGE_CONTAINER_DOCS     = module.quantumems-storage[each.key].documents_container_name
      BACKEND_URL                      = "https://${var.app_service_name}-${each.key}.azurewebsites.net"
    }
  )
}
