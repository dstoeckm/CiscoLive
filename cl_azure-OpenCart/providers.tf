// Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    tetration = {
      source  = "CiscoDevNet/tetration"
      version = "0.1.1"
    }
  }
}
 

provider "azurerm" {
   features {
     resource_group {
       prevent_deletion_if_contains_resources = false
    }
  }
}
