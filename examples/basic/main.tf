resource "azurerm_resource_group" "this" {
  name     = "my-rg"
  location = "West Europe"
}
resource "random_pet" "this" {}

module "postgresql_server" {
  source = "../.."

  name                = random_pet.this.id
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  administrator_login = "admintest"
}
