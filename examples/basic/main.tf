resource "azurerm_resource_group" "example" {
  name     = "my-rg"
  location = "West Europe"
}
resource "random_pet" "psql" {}

module "postgresql_server" {
  source = "../.."

  name                = random_pet.psql.id
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  administrator_login = "admintest"
}
