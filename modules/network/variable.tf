variable "virtualnetwork_name" {
  type        = string
  description = "The name of the virtual network."
}

variable "location" {
  type        = string
  description = "The Azure region where resources will be provisioned."
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resources."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the resources are created."
}

variable "subnet_agw_name" {
  type        = string
  description = "The name of the Application Gateway subnet."
}

variable "subnet_agw_cidr" {
  type        = string
  description = "The address prefix for the Application Gateway subnet."
}

variable "subnet_pe_name" {
  type        = string
  description = "The name of the Private Endpoint subnet."
}

variable "subnet_pe_cidr" {
  type        = string
  description = "The address prefix for the Private Endpoint subnet."
}

variable "subnet_db_name" {
  type        = string
  description = "The name of the Database subnet."
}

variable "subnet_db_cidr" {
  type        = string
  description = "The address prefix for the Database subnet."
}

variable "subnet_app_name" {
  type        = string
  description = "The name of the Application/Backend subnet."
}

variable "subnet_app_cidr" {
  type        = string
  description = "The address prefix for the Application/Backend subnet."
}

variable "address_space" {
  type        = string
  description = "The address space that is used by the virtual network."
  default     = "10.0.0.0/24"
}

variable "nsg_db_name" {
  type        = string
  description = "The name of the Network Security Group for the Database subnet."
  default     = "nsg-db-dev-cin"
}

variable "nsg_db_rule_name" {
  type        = string
  description = "The name of the security rule for database access."
  default     = "allow-postgres-from-vnet"
}

variable "nsg_db_rule_priority" {
  type        = number
  description = "The priority of the database security rule."
  default     = 100
}

variable "nsg_db_rule_direction" {
  type        = string
  description = "The direction of traffic for the security rule."
  default     = "Inbound"
}

variable "nsg_db_rule_access" {
  type        = string
  description = "Specifies whether network traffic is allowed or denied."
  default     = "Allow"
}

variable "nsg_db_rule_protocol" {
  type        = string
  description = "Network protocol this rule applies to."
  default     = "Tcp"
}

variable "nsg_db_rule_source_port_range" {
  type        = string
  description = "Source Port or Range."
  default     = "*"
}

variable "nsg_db_rule_destination_port_range" {
  type        = string
  description = "Destination Port or Range."
  default     = "5432"
}

variable "nsg_db_rule_source_address_prefix" {
  type        = string
  description = "CIDR or source IP range or service tag allowed database access."
  default     = "VirtualNetwork"
}

variable "nsg_db_rule_destination_address_prefix" {
  type        = string
  description = "CIDR or destination IP range or service tag for the security rule."
  default     = "*"
}

variable "subnet_db_service_endpoints" {
  type        = list(string)
  description = "The list of Service endpoints to associate with the database subnet."
  default     = ["Microsoft.Storage"]
}

variable "subnet_pe_network_policies" {
  type        = string
  description = "Enable or Disable network policies for the private endpoint on the subnet."
  default     = "Disabled"
}

variable "private_dns_zone_name" {
  type        = string
  description = "The name of the private DNS zone for PostgreSQL. Must end with .postgres.database.azure.com"
  default     = "quantumems.postgres.database.azure.com"
}
