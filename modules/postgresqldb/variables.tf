variable "postgresqldb_name" {
  description = "Name of the PostgreSQL server"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group for the PostgreSQL server"
  type        = string
}

variable "location" {
  description = "Location of the PostgreSQL server"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the PostgreSQL server"
  type        = map(string)
}

variable "admin_password" {
  description = "Password for the admin user"
  type        = string
}

variable "admin_username" {
  description = "Username for the admin user"
  type        = string
}

variable "pg_version" {
  description = "Version of PostgreSQL"
  type        = string
}

variable "storage_mb" {
  description = "Storage size in MB"
  type        = number
}

variable "sku_name" {
  description = "SKU name for the PostgreSQL server"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for the PostgreSQL server"
  type        = string
}

variable "dns_zone_id" {
  description = "ID of the DNS zone for the PostgreSQL server"
  type        = string
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled for this server."
  type        = bool
  default     = false
}