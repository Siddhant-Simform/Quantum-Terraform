# ─── Identity ─────────────────────────────────────────────────────────────────

variable "resource_group_name" {
  type        = string
  description = "Name of the Resource Group where the Storage Account will be created."
}

variable "location" {
  type        = string
  description = "Azure region for the Storage Account."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources created by this module."
  default     = {}
}

# ─── Naming ───────────────────────────────────────────────────────────────────

variable "storage_account_name" {
  type        = string
  description = "Globally unique name for the Storage Account (3-24 chars, lowercase alphanumeric only)."
}

# ─── SKU / Kind ───────────────────────────────────────────────────────────────

variable "account_tier" {
  type        = string
  description = "Storage account tier. 'Standard' for HDD-backed, 'Premium' for SSD-backed."
  default     = "Standard"
}

variable "replication_type" {
  type        = string
  description = "Replication strategy: LRS | GRS | RAGRS | ZRS | GZRS | RAGZRS."
  default     = "LRS"
}

# ─── Blob Settings ────────────────────────────────────────────────────────────

variable "blob_soft_delete_days" {
  type        = number
  description = "Number of days blobs are retained after soft-delete (0 = disabled)."
  default     = 7
}

variable "blob_versioning_enabled" {
  type        = bool
  description = "Enable blob versioning so previous versions of profile images/docs can be restored."
  default     = true
}

# ─── Networking ───────────────────────────────────────────────────────────────

variable "virtual_network_id" {
  type        = string
  description = "Resource ID of the VNet to link the Private DNS Zone to."
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "Resource ID of subnet-pe — the Private Endpoint NIC is placed here."
}

variable "allowed_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs allowed to access storage via service endpoints (optional; PE is the primary path)."
  default     = []
}
