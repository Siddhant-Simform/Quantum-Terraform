variable "acr_name" {
  type        = string
  description = "Name of the container registry."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "location" {
  type        = string
  description = "Location of the resource group."
}

variable "acr_sku" {
  type        = string
  description = "SKU of the container registry."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the resource."
}
