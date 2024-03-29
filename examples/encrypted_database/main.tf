resource "random_pet" "kv" {}
resource "random_pet" "psql" {}

data "azurerm_client_config" "this" {}

resource "azurerm_resource_group" "this" {
  name     = "padok-test-rg"
  location = "West Europe"
}

module "keyvault" {
  source              = "git@github.com:padok-team/terraform-azurerm-keyvault?ref=v0.5.0"
  name                = random_pet.kv.id
  resource_group      = azurerm_resource_group.this
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.this.tenant_id
  
  network_acls = {
    ip_rules                   = ["0.0.0.0/0"]
    virtual_network_subnet_ids = []
  }

  depends_on = [
    azurerm_resource_group.this
  ]
}

resource "azurerm_key_vault_access_policy" "server" {
  key_vault_id = module.keyvault.this.id
  tenant_id    = data.azurerm_client_config.this.tenant_id
  object_id    = module.postgresql_server.this.identity[0].principal_id

  key_permissions    = ["Get", "UnwrapKey", "WrapKey"]
  secret_permissions = ["Get"]
}

resource "azurerm_key_vault_access_policy" "client" {
  key_vault_id = module.keyvault.this.id
  tenant_id    = data.azurerm_client_config.this.tenant_id
  object_id    = data.azurerm_client_config.this.object_id

  key_permissions    = ["Get", "Create", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify"]
  secret_permissions = ["Get"]
}

#tfsec:ignore:azure-keyvault-ensure-key-expiry
resource "azurerm_key_vault_key" "this" {
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

  name                   = random_pet.psql.id
  resource_group_name    = azurerm_resource_group.this.name
  location               = azurerm_resource_group.this.location
  administrator_login    = "admintest"
  administrator_password = "P4d0k!B3stT3@m"

  custom_encryption_enabled = true
  customer_managed_key_id   = azurerm_key_vault_key.this.id
  databases = {
    "db1" = { charset = "UTF8", collation = "en-US" },
    "db2" = { charset = "UTF8", collation = "en-US" },
    "db3" = { charset = "UTF8", collation = "en-US" },
  }

  depends_on = [
    azurerm_key_vault_key.this,
  ]
}
