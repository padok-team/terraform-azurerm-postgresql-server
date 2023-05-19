resource "azurerm_resource_group" "this" {
  name     = "my-rg"
  location = "West Europe"
}
resource "random_pet" "this" {}

module "postgresql_server" {
  source = "../.."

  name                = random_pet.this.id
  resource_group      = azurerm_resource_group.this
  administrator_login = "admintest"
}
