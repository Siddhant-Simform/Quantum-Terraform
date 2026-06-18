variable "keyvault_name" {
  type        = string
  description = "The name of the Key Vault."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "location" {
  type        = string
  description = "The Azure region to deploy the Key Vault."
}

variable "sku_name" {
  type        = string
  description = "The SKU name of the Key Vault (standard or premium)."
  default     = "standard"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the Key Vault."
}

variable "rbac_authorization_enabled" {
  type        = bool
  description = "Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) authorization."
  default     = true
}

variable "principal_id" {
  type        = string
  description = "The principal ID to assign the Key Vault role to. If not specified, defaults to the current deploying principal."
  default     = ""
}

variable "role_definition_name" {
  type        = string
  description = "The name of the role to assign to the principal."
  default     = "Key Vault Secrets Officer"
}

variable "virtual_network_id" {
  type        = string
  description = "The ID of the virtual network to link the Private DNS Zone."
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "The ID of the subnet where the Private Endpoint will be created."
}

