module "quantumems-dev-rg-cin" {
  source   = "../../modules/resource-group"
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

module "quantumems-dev-network-cin" {
  source              = "../../modules/network"
  resource_group_name = module.quantumems-dev-rg-cin.rg_name
  location            = module.quantumems-dev-rg-cin.location
  tags                = var.tags

  virtualnetwork_name = var.virtualnetwork_name
  address_space       = var.address_space

  subnet_agw_name = var.subnet_agw_name
  subnet_agw_cidr = var.subnet_agw_cidr

  subnet_pe_name = var.subnet_pe_name
  subnet_pe_cidr = var.subnet_pe_cidr

  subnet_db_name = var.subnet_db_name
  subnet_db_cidr = var.subnet_db_cidr

  subnet_app_name = var.subnet_app_name
  subnet_app_cidr = var.subnet_app_cidr

  nsg_db_name = var.nsg_db_name
}

module "quantumems-dev-postgresqldbsvr-cin" {
  source              = "../../modules/postgresqldb"
  resource_group_name = module.quantumems-dev-rg-cin.rg_name
  postgresqldb_name   = "quantumems-dev-postgresqldbsvr-cin"
  location            = module.quantumems-dev-rg-cin.location
  tags                = var.tags
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  sku_name            = var.sku_name
  storage_mb          = var.storage_mb
  pg_version          = var.pg_version
  subnet_id           = module.quantumems-dev-network-cin.subnet_db_id
  dns_zone_id         = module.quantumems-dev-network-cin.private_dns_zone_id
}

module "quantumems-dev-keyvault-cin" {
  source              = "../../modules/keyvault"
  resource_group_name = module.quantumems-dev-rg-cin.rg_name
  location            = module.quantumems-dev-rg-cin.location
  tags                = var.tags
  keyvault_name       = "quantumems-dev-kv-cin"
  sku_name            = "standard"
}

