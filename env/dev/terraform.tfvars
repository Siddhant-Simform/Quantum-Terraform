resource_groups = {
  dev = {
    rg_name  = "quantumems-dev-rg-cin"
    location = "centralindia"

    network = {
      vnet_name     = "quantumems-dev-vnet-cin"
      address_space = "10.0.0.0/16"
      nsg_db_name   = "nsg-db-dev-cin"

      subnets = {
        agw = {
          name              = "subnet-agw"
          cidr              = "10.0.1.0/24"
          delegation        = null
          service_endpoints = []
        }
        pe = {
          name              = "subnet-pe"
          cidr              = "10.0.2.0/24"
          delegation        = null
          service_endpoints = []
        }
        db = {
          name              = "subnet-db"
          cidr              = "10.0.3.0/24"
          delegation        = "postgresql"
          service_endpoints = ["Microsoft.Storage"]
        }
        app = {
          name              = "subnet-app"
          cidr              = "10.0.4.0/24"
          delegation        = "appservice"
          service_endpoints = []
        }
      }
    }
  }
}

tags = {
  project_name = "quantum-EMS"
  environment  = "dev"
  managed_by   = "terraform"
  owner        = "Siddhant"
}

# PostgreSQL Server configurations
admin_username = "quantumadmin"
admin_password = "Password@123"
sku_name       = "B_Standard_B2s"
storage_mb     = 32768
pg_version     = "18"

# Static Web App configurations
swa_app_name   = "quantumems-demo-app-cin"
swa_location   = "eastasia"
repository_url = "https://github.com/Siddhant-Simform/EMS-frontend"
branch         = "main"

# ACR
acr_sku = "Standard"

# App Service Plan
app_plan_name        = "quantumems-dev-plan-cin"
app_service_name     = "quantumems-dev-app-cin"
app_service_sku_name = "B1"
app_os_type          = "Linux"

# App Service site configuration
app_always_on           = false
app_https_only          = true
app_minimum_tls_version = "1.2"
app_log_retention_days  = 7

# Docker image — tag updated after each CI/CD build
# docker_registry_username and docker_registry_password are auto-sourced from ACR outputs
docker_image_name = "backend-ems:1.2"

# CORS — set allowed origins AFTER first terraform apply
# Step 1: Run terraform apply (cors block omitted, no provider bug)
# Step 2: Get SWA URL: terraform output -json | jq ...
# Step 3: Update cors_allowed_origins below and run terraform apply again
cors_allowed_origins     = ["https://yellow-sky-0c4765200.7.azurestaticapps.net"]
cors_support_credentials = false

# App Settings (non-sensitive runtime environment variables)
# Sensitive values (DB connection string, JWT secret, etc.) → secrets.tfvars
# Storage connection string is auto-injected from the storage module output — do NOT add it here.
app_settings = {
  WEBSITES_PORT      = "3000"
  NODE_ENV           = "production"
  WEBSITE_DNS_SERVER = "168.63.129.16"
}

# ─── Storage Account ──────────────────────────────────────────────────────────
# Will create: Storage Account "qemssadevcin" (Central India, LRS)
#   Containers:  profile-images   ← employee profile pictures
#                documents        ← employee PDFs / documents
# Access: Private only — App Service reaches it via Private Endpoint in subnet-pe
storage_account_tier            = "Standard"
storage_replication_type        = "LRS"
storage_blob_soft_delete_days   = 7
storage_blob_versioning_enabled = true
