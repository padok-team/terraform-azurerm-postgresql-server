provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "example" {
  name     = "padok-test-rg"
  location = "West Europe"
}

module "keyvault" {
  source              = "git@github.com:padok-team/terraform-azurerm-keyvault?ref=v0.1.0"
  name                = "padok-pgsql-keyvault"
  resource_group_name = azurerm_resource_group.example.name
  sku_name            = "standard"

  network_acls = {
    ip_rules                   = ["0.0.0.0/0"]
    virtual_network_subnet_ids = []
  }

  depends_on = [
    azurerm_resource_group.example
  ]
}

resource "azurerm_key_vault_access_policy" "server" {
  key_vault_id = module.keyvault.this.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.postgresql_server.principal_id

  key_permissions    = ["get", "unwrapkey", "wrapkey"]
  secret_permissions = ["get"]
}

resource "azurerm_key_vault_access_policy" "client" {
  key_vault_id = module.keyvault.this.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions    = ["get", "create", "delete", "list", "restore", "recover", "unwrapkey", "wrapkey", "purge", "encrypt", "decrypt", "sign", "verify"]
  secret_permissions = ["get"]
}

resource "azurerm_key_vault_key" "example" {
  name         = "padok-private-key"
  key_vault_id = module.keyvault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  depends_on = [
    azurerm_key_vault_access_policy.client
  ]
}

module "postgresql_server" {
  source = "../.."

  name                   = "my-postgresql-server"
  resource_group_name    = azurerm_resource_group.example.name
  location               = azurerm_resource_group.example.location
  administrator_login    = "admintest"
  administrator_password = "P4d0k!B3stT3@m"

  custom_encryption_enabled = true
  customer_managed_key_id   = azurerm_key_vault_key.example.id

  depends_on = [
    azurerm_key_vault_key.example
  ]

  databases = {
    "db1" = { charset = "UTF8", collation = "en-US" },
    "db2" = { charset = "UTF8", collation = "en-US" },
    "db3" = { charset = "UTF8", collation = "en-US" },
  }
}
