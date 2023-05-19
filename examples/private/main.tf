resource "random_pet" "this" {}

resource "azurerm_resource_group" "this" {
  name     = random_pet.this.id
  location = "France Central"
}

module "postgresql_server" {
  source = "../.."

  name                   = random_pet.this.id
  resource_group         = azurerm_resource_group.this
  administrator_login    = "admintest"
  administrator_password = "padok"

  private_endpoint = {
    enable              = true
    subnet_id           = azurerm_subnet.this.id
    private_dns_zone_id = azurerm_private_dns_zone.this.id
  }
}
