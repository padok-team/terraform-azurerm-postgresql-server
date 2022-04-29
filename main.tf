locals {
  pg_configs = merge({
    "log_connections" : "on",
    "log_disconnections" : "ON",
    "log_duration" : "ON",
    "log_retention_days" : "7",
  }, var.pg_configs)

  backup_databases = var.backup_configuration != null ? toset(keys(var.databases)) : toset([])
}

resource "random_password" "this" {
  # Generate a random password if the administrator_password is not set
  count  = var.administrator_password != null ? 0 : 1
  length = 64
}

resource "azurerm_postgresql_server" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku_name   = var.sku_name
  storage_mb = var.storage_mb
  version    = var.pg_version

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_password != null ? var.administrator_password : random_password.this[0].result

  ssl_enforcement_enabled          = var.ssl_enforcement_enabled
  ssl_minimal_tls_version_enforced = var.ssl_minimal_tls_version_enforced

  public_network_access_enabled     = var.public_network_access_enabled
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  threat_detection_policy {
    enabled                    = lookup(var.threat_detection_policy, "enabled", true)
    disabled_alerts            = lookup(var.threat_detection_policy, "disabled_alerts", null)
    email_account_admins       = lookup(var.threat_detection_policy, "email_account_admins", null)
    email_addresses            = lookup(var.threat_detection_policy, "email_addresses", null)
    retention_days             = lookup(var.threat_detection_policy, "retention_days", 30)
    storage_account_access_key = lookup(var.threat_detection_policy, "storage_account_access_key", null)
    storage_endpoint           = lookup(var.threat_detection_policy, "storage_endpoint", null)
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_postgresql_database" "these" {
  for_each = var.databases

  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.this.name
  charset             = each.value.charset != null ? each.value.charset : "UTF8"
  collation           = each.value.collation != null ? each.value.collation : "en_US.UTF8"
}

resource "azurerm_postgresql_configuration" "these" {
  for_each            = local.pg_configs
  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.this.name
  value               = each.value
}

resource "azurerm_postgresql_server_key" "this" {
  count = var.custom_encryption_enabled ? 1 : 0

  server_id        = azurerm_postgresql_server.this.id
  key_vault_key_id = var.customer_managed_key_id
}

resource "azurerm_postgresql_firewall_rule" "these" {
  for_each            = var.firewall_rules
  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.this.name
  start_ip_address    = each.value.start_ip_address
  end_ip_address      = each.value.end_ip_address
}

resource "azurerm_data_protection_backup_instance_postgresql" "these" {
  for_each = local.backup_databases

  name                                    = each.key
  location                                = var.location
  database_id                             = azurerm_postgresql_database.these[each.key].id
  vault_id                                = var.backup_configuration.vault_id
  backup_policy_id                        = var.backup_configuration.backup_policy_id
  database_credential_key_vault_secret_id = var.backup_configuration.database_credential_key_vault_secret_id
}
