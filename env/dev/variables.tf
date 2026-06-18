variable "resource_groups" {
  description = "Map of full stack configurations. Each key is an environment identifier (e.g. 'dev', 'staging')."
  type = map(object({
    rg_name  = string
    location = string

    network = object({
      vnet_name     = string
      address_space = string
      nsg_db_name   = string
      subnets = map(object({
        name              = string
        cidr              = string
        delegation        = optional(string) # "postgresql" | "appservice" | null
        service_endpoints = list(string)
      }))
    })
  }))
}

# ─── Global / shared variables ────────────────────────────────────────────────

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources."
}

# ─── PostgreSQL ────────────────────────────────────────────────────────────────

variable "admin_username" {
  type        = string
  description = "Administrator username for PostgreSQL server."
}

variable "admin_password" {
  type        = string
  description = "Administrator password for PostgreSQL server."
  sensitive   = true
}

variable "sku_name" {
  type        = string
  description = "The SKU Name for the PostgreSQL Flexible Server."
}

variable "storage_mb" {
  type        = number
  description = "PostgreSQL storage size in MB."
}

variable "pg_version" {
  type        = string
  description = "PostgreSQL major version."
}

# ─── Static Web App ───────────────────────────────────────────────────────────

variable "swa_location" {
  type        = string
  description = "Azure region for the Static Web App (must be a supported SWA region)."
}

variable "swa_app_name" {
  type        = string
  description = "Base name of the Static Web App. Environment key is appended automatically."
}

variable "repository_url" {
  type        = string
  description = "GitHub repository URL for the Static Web App."
}

variable "branch" {
  type        = string
  description = "Repository branch to deploy."
}

variable "custom_domain" {
  type        = string
  description = "Optional custom domain for the Static Web App."
  default     = null
}

# ─── App Service ──────────────────────────────────────────────────────────────

variable "app_plan_name" {
  type        = string
  description = "Base name of the App Service Plan. Environment key is appended automatically."
}

variable "app_service_name" {
  type        = string
  description = "Base name of the Linux Web App. Environment key is appended automatically."
}

variable "app_service_sku_name" {
  type        = string
  description = "SKU name for the App Service Plan (e.g. B1, P1v3)."
}

variable "app_os_type" {
  type        = string
  description = "OS type for the App Service Plan. Must be 'Linux' for container workloads."
  default     = "Linux"
}

variable "app_always_on" {
  type        = bool
  description = "Keep the app loaded when idle. Requires Basic SKU or higher."
  default     = false
}

variable "app_https_only" {
  type        = bool
  description = "Redirect all HTTP traffic to HTTPS."
  default     = true
}

variable "app_minimum_tls_version" {
  type        = string
  description = "Minimum TLS version for the Web App."
  default     = "1.2"
}

variable "app_log_retention_days" {
  type        = number
  description = "Number of days to retain HTTP logs on the local file system (0 = disabled)."
  default     = 7
}

# ─── Docker / ACR ─────────────────────────────────────────────────────────────

variable "docker_image_name" {
  type        = string
  description = "Docker image name and tag pushed to ACR (e.g. backend:latest)."
  default     = "backend:latest"
}

# ─── CORS ─────────────────────────────────────────────────────────────────────

variable "cors_allowed_origins" {
  type        = list(string)
  description = "CORS allowed origins for the Web App. Set to the Static Web App URL after first apply. Leave empty ([]) on the first apply to avoid the AzureRM provider 'block count changed' bug."
  default     = []
}

variable "cors_support_credentials" {
  type        = bool
  description = "Whether CORS allows credentials (cookies / auth headers)."
  default     = false
}

# ─── App Settings (runtime environment variables) ─────────────────────────────

variable "app_settings" {
  type        = map(string)
  description = "Non-sensitive environment variables injected into the Web App at runtime."
  default     = {}
}

variable "sensitive_app_settings" {
  type        = map(string)
  description = "Sensitive environment variables (DATABASE_URL, JWT_SECRET, etc.) injected into the Web App. Pass via secrets.tfvars — never commit to source control."
  sensitive   = true
  default     = {}
}


# ─── Azure Container Registry ─────────────────────────────────────────────────

variable "acr_sku" {
  type        = string
  description = "SKU tier for the Container Registry (Basic | Standard | Premium)."
}

# ─── Storage Account ──────────────────────────────────────────────────────────

variable "storage_account_tier" {
  type        = string
  description = "Storage account tier: Standard (HDD) or Premium (SSD)."
  default     = "Standard"
}

variable "storage_replication_type" {
  type        = string
  description = "Replication strategy for the Storage Account: LRS | GRS | ZRS | GZRS."
  default     = "LRS"
}

variable "storage_blob_soft_delete_days" {
  type        = number
  description = "Number of days blobs are retained after soft-delete (1-365). Set to 0 to disable."
  default     = 7
}

variable "storage_blob_versioning_enabled" {
  type        = bool
  description = "Enable blob versioning so previous profile image/document versions can be restored."
  default     = true
}
