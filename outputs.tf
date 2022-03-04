output "id" {
  value       = azurerm_postgresql_server.this.id
  description = "The ID of the PostgreSQL server."
}

output "name" {
  value       = azurerm_postgresql_server.this.name
  description = "The PostgreSQL server name."
}

output "fqdn" {
  value       = azurerm_postgresql_server.this.fqdn
  description = "The PostgreSQL server's fully qualified domain name (FQDN)."
}

output "username" {
  value       = azurerm_postgresql_server.this.administrator_login
  description = "The PostgreSQL server administrator's username."
}

output "password" {
  value       = azurerm_postgresql_server.this.administrator_login_password
  description = "The PostgreSQL server administrator's password."
}

output "principal_id" {
  value       = azurerm_postgresql_server.this.identity[0].principal_id
  description = "The Client ID of the Service Principal assigned to this PostgreSQL Server."
}

output "tenant_id" {
  value       = azurerm_postgresql_server.this.identity[0].tenant_id
  description = "The ID of the Tenant the Service Principal is assigned in."
}
