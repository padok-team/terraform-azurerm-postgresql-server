provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "my-rg"
  location = "France Central"
}

module "network" {
  source = "git@github.com:padok-team/terraform-azurerm-network.git?ref=v0.1.0"

  resource_group     = azurerm_resource_group.example
  vnet_name          = "my-vnet"
  vnet_address_space = ["10.0.0.0/8"]
  subnets = {
    "subnet1" = "10.0.0.0/16",
  }
}

module "postgresql_server" {
  source = "../.."

  name                = "my-postgresql-server"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  administrator_login = "admintest"

  public_network_access_enabled = true

  allowed_subnet_ids = [module.network.subnets["subnet1"].this.id]
}
