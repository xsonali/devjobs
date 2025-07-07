# backend.tf (DO NOT pust this file to GitHub)

terraform {
  backend "azurerm" {
    resource_group_name  = "REPLACE_ME"          # Your actual resource group name
    storage_account_name = "REPLACE_ME"          # Your Azure Storage Account name
    container_name       = "REPLACE_ME"               # Blob container name for state files
    key                  = "REPLACE_ME" # State file name
  }
}
