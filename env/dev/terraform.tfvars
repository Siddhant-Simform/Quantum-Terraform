rg_name  = "quantumems-dev-rg-cin"
location = "centralindia"

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


# Network configurations
virtualnetwork_name = "quantumems-dev-vnet-cin"
address_space       = "10.0.0.0/16"

subnet_agw_name = "subnet-agw"
subnet_agw_cidr = "10.0.1.0/24"

subnet_pe_name = "subnet-pe"
subnet_pe_cidr = "10.0.2.0/24"

subnet_db_name = "subnet-db"
subnet_db_cidr = "10.0.3.0/24"

subnet_app_name = "subnet-app"
subnet_app_cidr = "10.0.4.0/24"

nsg_db_name = "nsg-db-dev-cin"

keyvault_name = "quantumemdevkvcin"


public_network_access_enabled = false