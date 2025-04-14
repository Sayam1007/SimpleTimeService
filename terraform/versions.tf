################################################################################
# Versions.tf 
################################################################################

terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "data-coe-tfstate"
    storage_account_name = "datacoetfstate"
    container_name       = "tfstate"
    key                  = "Simple/terraform.tfstate"
  }
}