provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "my-rg"
  location = "West Europe"
}

module "postgresql_server" {
  source = "../.."

  name                = "my-postgresql-server"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  administrator_login = "admintest"

  databases = {
    "db1" = { charset = "UTF8", collation = "en-US" },
    "db2" = { charset = "UTF8", collation = "en-US" },
    "db3" = { charset = "UTF8", collation = "en-US" },
  }
}
