resource "azurerm_virtual_network" "virtualnetwork" {
  name                = var.virtualnetwork_name
  address_space       = [var.address_space]
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_subnet" "agw" {
  name                 = var.subnet_agw_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtualnetwork.name
  address_prefixes     = [var.subnet_agw_cidr]
}

resource "azurerm_subnet" "pe" {
  name                              = var.subnet_pe_name
  resource_group_name               = var.resource_group_name
  virtual_network_name              = azurerm_virtual_network.virtualnetwork.name
  address_prefixes                  = [var.subnet_pe_cidr]
  private_endpoint_network_policies = var.subnet_pe_network_policies
}

resource "azurerm_subnet" "db" {
  name                 = var.subnet_db_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtualnetwork.name
  address_prefixes     = [var.subnet_db_cidr]
  service_endpoints    = var.subnet_db_service_endpoints

  delegation {
    name = "db-delegation"
    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "app" {
  name                 = var.subnet_app_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtualnetwork.name
  address_prefixes     = [var.subnet_app_cidr]
}

resource "azurerm_network_security_group" "nsg_db" {
  name                = var.nsg_db_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "nsg_rule_1" {
  name                        = var.nsg_db_rule_name
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_db.name
  priority                    = var.nsg_db_rule_priority
  direction                   = var.nsg_db_rule_direction
  access                      = var.nsg_db_rule_access
  protocol                    = var.nsg_db_rule_protocol
  source_port_range           = var.nsg_db_rule_source_port_range
  destination_port_range      = var.nsg_db_rule_destination_port_range
  source_address_prefix       = var.nsg_db_rule_source_address_prefix
  destination_address_prefix  = var.nsg_db_rule_destination_address_prefix
}

resource "azurerm_subnet_network_security_group_association" "db" {
  subnet_id                 = azurerm_subnet.db.id
  network_security_group_id = azurerm_network_security_group.nsg_db.id
}

resource "azurerm_private_dns_zone" "postgres" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
  name                  = "${azurerm_virtual_network.virtualnetwork.name}-pdz-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  virtual_network_id    = azurerm_virtual_network.virtualnetwork.id
  tags                  = var.tags
}