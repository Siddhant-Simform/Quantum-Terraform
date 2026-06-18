resource "azurerm_virtual_network" "virtualnetwork" {
  name                = var.virtualnetwork_name
  address_space       = [var.address_space]
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# Delegation lookup map — keeps tfvars clean (use a simple string key)
locals {
  delegation_configs = {
    postgresql = {
      name = "db-delegation"
      service_delegation = {
        name    = "Microsoft.DBforPostgreSQL/flexibleServers"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    }
    appservice = {
      name = "app-delegation"
      service_delegation = {
        name    = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  }

  # Enrich each subnet entry with resolved delegation object
  subnets = {
    for key, subnet in var.subnets : key => merge(subnet, {
      delegation_config = subnet.delegation != null ? local.delegation_configs[subnet.delegation] : null
      pe_network_policy = key == "pe" ? "Disabled" : "Enabled"
    })
  }
}

resource "azurerm_subnet" "subnets" {
  for_each             = local.subnets
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtualnetwork.name
  address_prefixes     = [each.value.cidr]
  service_endpoints    = each.value.service_endpoints
  private_endpoint_network_policies = each.value.pe_network_policy

  dynamic "delegation" {
    for_each = each.value.delegation_config != null ? [each.value.delegation_config] : []
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
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
  subnet_id                 = azurerm_subnet.subnets["db"].id
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