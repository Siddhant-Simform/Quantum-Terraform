variable "swa_location" {
    type = string
}

variable "resource_group_name" {
    type = string
}

variable "app_name" {
    type = string
}
variable "repository_url" {
    type = string
}

variable "branch" {
    type = string
}

variable "sku_tier" {
    type = string
    default = "Standard"
}

variable "sku_size" {
    type = string
    default = "Standard"
}

variable "tags" {
    type = map(string)
}   

