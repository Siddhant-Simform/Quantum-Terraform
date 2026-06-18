# ─── Identity / Placement ─────────────────────────────────────────────────────

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where App Service resources are deployed."
}

variable "location" {
  type        = string
  description = "Azure region for App Service resources."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources in this module."
  default     = {}
}

# ─── App Service Plan ─────────────────────────────────────────────────────────

variable "app_plan_name" {
  type        = string
  description = "Name of the App Service Plan."
}

variable "app_service_sku_name" {
  type        = string
  description = "SKU name for the App Service Plan (e.g. B1, P1v3)."
}

variable "os_type" {
  type        = string
  description = "OS type for the App Service Plan. Must be 'Linux'."
  default     = "Linux"
}

# ─── Linux Web App ────────────────────────────────────────────────────────────

variable "app_name" {
  type        = string
  description = "Name of the Linux Web App."
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet for regional VNet integration (app subnet)."
}

variable "https_only" {
  type        = bool
  description = "Redirect all HTTP traffic to HTTPS."
  default     = true
}

# ─── Site Config ──────────────────────────────────────────────────────────────

variable "always_on" {
  type        = bool
  description = "Keep the app loaded when idle. Requires Basic tier or higher."
  default     = false
}

variable "minimum_tls_version" {
  type        = string
  description = "Minimum TLS version enforced by the Web App."
  default     = "1.2"
}

# ─── Docker / ACR ─────────────────────────────────────────────────────────────

variable "acr_id" {
  type        = string
  description = "Resource ID of the Azure Container Registry — used as the scope for the AcrPull role assignment."
}

variable "docker_image_name" {
  type        = string
  description = "Docker image name and tag to deploy (e.g. backend:latest)."
}

variable "docker_registry_url" {
  type        = string
  description = "Full HTTPS URL of the container registry (e.g. https://myacr.azurecr.io)."
}

variable "docker_registry_username" {
  type        = string
  description = "Admin username for the container registry."
  sensitive   = true
}

variable "docker_registry_password" {
  type        = string
  description = "Admin password for the container registry."
  sensitive   = true
}

# ─── CORS ─────────────────────────────────────────────────────────────────────

variable "cors_allowed_origins" {
  type        = list(string)
  description = "List of origins permitted by CORS (e.g. Static Web App URL)."
  default     = []
}

variable "cors_support_credentials" {
  type        = bool
  description = "Whether CORS allows credentials (cookies / auth headers)."
  default     = false
}

# ─── Logging ──────────────────────────────────────────────────────────────────

variable "log_retention_days" {
  type        = number
  description = "Number of days to retain HTTP logs on the file system (0 = disabled)."
  default     = 7
}

# ─── App Settings (runtime environment variables) ─────────────────────────────

variable "app_settings" {
  type        = map(string)
  description = "Environment variables injected into the Web App at runtime."
  default     = {}
  sensitive   = true
}
