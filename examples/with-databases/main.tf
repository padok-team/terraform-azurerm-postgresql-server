provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "my-rg"
  location = "West Europe"
}

module "postgresql-server" {
  source = "../.."

  name                = "my-postgresql-server"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  administrator_login = "admintest"

  databases = {
    "db1" = { charset = "utf8", collation = "en_US.utf8" },
    "db2" = { charset = "utf8", collation = "en_US.utf8" },
    "db3" = { charset = "utf8", collation = "en_US.utf8" },
  }
}
