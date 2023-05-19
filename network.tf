resource "azurerm_private_endpoint" "this" {
  count = var.private_endpoint.enable ? 1 : 0

  name                = var.name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  subnet_id           = var.private_endpoint.subnet_id

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_endpoint.private_dns_zone_id]
  }

  # Reference: https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
  private_service_connection {
    name                           = var.name
    is_manual_connection           = false
    private_connection_resource_id = azurerm_postgresql_server.this.id
    subresource_names              = ["postgresqlServer"]
  }
  tags = var.tags
}
