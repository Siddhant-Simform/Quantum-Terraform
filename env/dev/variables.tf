variable "rg_name" {
  type        = string
  description = "The name of the resource group."
}

variable "location" {
  type        = string
  description = "The Azure region to deploy resources."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources."
}

variable "admin_username" {
  type        = string
  description = "Administrator username for PostgreSQL server."
}

variable "admin_password" {
  type        = string
  description = "Administrator password for PostgreSQL server."
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


# Network Module Variables
variable "virtualnetwork_name" {
  type        = string
  description = "The name of the virtual network."
}

variable "address_space" {
  type        = string
  description = "The CIDR address space for the virtual network."
}

variable "subnet_agw_name" {
  type        = string
  description = "The name of the Application Gateway subnet."
}

variable "subnet_agw_cidr" {
  type        = string
  description = "The CIDR block for the Application Gateway subnet."
}

variable "subnet_pe_name" {
  type        = string
  description = "The name of the Private Endpoint subnet."
}

variable "subnet_pe_cidr" {
  type        = string
  description = "The CIDR block for the Private Endpoint subnet."
}

variable "subnet_db_name" {
  type        = string
  description = "The name of the Database subnet."
}

variable "subnet_db_cidr" {
  type        = string
  description = "The CIDR block for the Database subnet."
}

variable "subnet_app_name" {
  type        = string
  description = "The name of the Backend App subnet."
}

variable "subnet_app_cidr" {
  type        = string
  description = "The CIDR block for the Backend App subnet."
}

variable "nsg_db_name" {
  type        = string
  description = "The name of the Network Security Group for the Database subnet."
}

variable "keyvault_name" {
  type        = string
  description = "The name of the Key Vault."
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether public network access is enabled for PostgreSQL server."
}