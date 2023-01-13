terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.4"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}
