resource "azurerm_virtual_network" "this" {
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  name = random_pet.this.id

  address_space = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "this" {
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name

  name = random_pet.this.id

  address_prefixes = ["10.0.0.0/28"]
}

resource "azurerm_private_dns_zone" "this" {
  # https://learn.microsoft.com/fr-fr/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                = random_pet.this.id
  resource_group_name = azurerm_resource_group.this.name
  virtual_network_id  = azurerm_virtual_network.this.id

  private_dns_zone_name = azurerm_private_dns_zone.this.name
}
