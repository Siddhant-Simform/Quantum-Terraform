terraform {
  backend "azurerm" {
    resource_group_name  = "rg-sentinelops-iac-shared-cin"
    storage_account_name = "sentinelopsstatesa"
    container_name       = "quantumems-state-file"
    key                  = "env/dev/terraform.tfstate"
  }
}
