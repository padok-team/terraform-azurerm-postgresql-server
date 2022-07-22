# Azurerm PostgreSQL server Terraform module

Terraform module which creates PostgreSQL server and databases resources on Azurerm.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [User Stories for this module](#user-stories-for-this-module)
- [Usage](#usage)
- [Examples](#examples)
- [Modules](#modules)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## User Stories for this module

- AAOPS I can enable backup on my database
- AAOPS I can have a SystemAssigned identity
- AAOPS I can integrate multiple databases in my server
- AAOPS I can configure firewall rules
- AAOPS I can encrypt my database

## Usage

```hcl
resource "azurerm_resource_group" "example" {
  name     = "my-rg"
  location = "West Europe"
}

module "postgresql_server" {
  source = "https://github.com/padok-team/terraform-azurerm-postgresql-server?ref=v0.1.0"

  name                = "my-postgresql-server"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  administrator_login = "admintest"
}
```

## Examples

- [Minimal database deployment configuration](examples/basic/main.tf)
- [Encrypted database configuration](examples/encrypted_database/main.tf)

<!-- BEGIN_TF_DOCS -->
## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_administrator_login"></a> [administrator\_login](#input\_administrator\_login) | The administrator login for the PostgreSQL Server. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location of the PostgreSQL server. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the PostgreSQL server. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group containing the PostgreSQL server. | `string` | n/a | yes |
| <a name="input_administrator_password"></a> [administrator\_password](#input\_administrator\_password) | The administrator password for the PostgreSQL Server. If not provided, one will be generated. | `string` | `null` | no |
| <a name="input_backup_configuration"></a> [backup\_configuration](#input\_backup\_configuration) | Postgresql Databases Data Protection Backup Instances configuration. | <pre>object({<br>    vault_id                                = string<br>    backup_policy_id                        = string<br>    database_credential_key_vault_secret_id = string<br>  })</pre> | `null` | no |
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | The backup retention days for the PostgreSQL Server. Possible values are between 7 and 35 days. | `number` | `30` | no |
| <a name="input_custom_encryption_enabled"></a> [custom\_encryption\_enabled](#input\_custom\_encryption\_enabled) | Whether to use a customer managed key for the PostgreSQL server. | `bool` | `false` | no |
| <a name="input_customer_managed_key_id"></a> [customer\_managed\_key\_id](#input\_customer\_managed\_key\_id) | The ID of the Customer Managed Key to use for the PostgreSQL Server. | `string` | `null` | no |
| <a name="input_databases"></a> [databases](#input\_databases) | A mapping with the databases to create. | <pre>map(object({<br>    collation = string<br>    charset   = string<br>  }))</pre> | `{}` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | A map of firewall rules. | <pre>map(object({<br>    start_ip_address = string<br>    end_ip_address   = string<br>  }))</pre> | `{}` | no |
| <a name="input_geo_redundant_backup_enabled"></a> [geo\_redundant\_backup\_enabled](#input\_geo\_redundant\_backup\_enabled) | Is Geo-Redundant backup enabled on the PostgreSQL Server. Defaults to true. | `bool` | `true` | no |
| <a name="input_infrastructure_encryption_enabled"></a> [infrastructure\_encryption\_enabled](#input\_infrastructure\_encryption\_enabled) | Should infrastructure encryption be enabled. Defaults to false, as the setting doesn't seem to stay enabled. | `bool` | `false` | no |
| <a name="input_pg_configs"></a> [pg\_configs](#input\_pg\_configs) | A mapping with the PostgreSQL configurations to apply. | `map(any)` | `{}` | no |
| <a name="input_pg_version"></a> [pg\_version](#input\_pg\_version) | The version of the PostgreSQL Server. Valid values are 9.5, 9.6, 10, 10.0, and 11. | `string` | `"11"` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether or not public network access is enabled. | `bool` | `false` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | Specifies the SKU Name for this PostgreSQL Server. The name of the SKU follows the tier + family + cores pattern (e.g. B\_Gen4\_1, GP\_Gen5\_8). | `string` | `"GP_Gen5_2"` | no |
| <a name="input_ssl_enforcement_enabled"></a> [ssl\_enforcement\_enabled](#input\_ssl\_enforcement\_enabled) | Whether SSL enforcement is enabled for the PostgreSQL Server. | `bool` | `true` | no |
| <a name="input_ssl_minimal_tls_version_enforced"></a> [ssl\_minimal\_tls\_version\_enforced](#input\_ssl\_minimal\_tls\_version\_enforced) | The minimal TLS version enforced by the PostgreSQL Server. | `string` | `"TLS1_2"` | no |
| <a name="input_storage_mb"></a> [storage\_mb](#input\_storage\_mb) | The max storage size of the PostgreSQL Server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 16777216 MB(16TB) for General Purpose/Memory Optimized SKUs. | `number` | `5120` | no |
| <a name="input_system_assigned_identity"></a> [system\_assigned\_identity](#input\_system\_assigned\_identity) | Whether or not to create a system assigned identity. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the PostgreSQL server. | `map(string)` | `{}` | no |
| <a name="input_threat_detection_policy"></a> [threat\_detection\_policy](#input\_threat\_detection\_policy) | Configure threat detection policy for pg server. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | The PostgreSQL server's fully qualified domain name (FQDN). |
| <a name="output_id"></a> [id](#output\_id) | The ID of the PostgreSQL server. |
| <a name="output_name"></a> [name](#output\_name) | The PostgreSQL server name. |
| <a name="output_password"></a> [password](#output\_password) | The PostgreSQL server administrator's password. |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | The Client ID of the Service Principal assigned to this PostgreSQL Server. |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | The ID of the Tenant the Service Principal is assigned in. |
| <a name="output_username"></a> [username](#output\_username) | The PostgreSQL server administrator's username. |
<!-- END_TF_DOCS -->

## License

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
