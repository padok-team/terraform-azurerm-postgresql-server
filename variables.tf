variable "name" {
  type        = string
  description = "The name of the PostgreSQL server."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group containing the PostgreSQL server."
}

variable "location" {
  type        = string
  description = "The location of the PostgreSQL server."
}

variable "sku_name" {
  type        = string
  description = "Specifies the SKU Name for this PostgreSQL Server. The name of the SKU follows the tier + family + cores pattern (e.g. B_Gen4_1, GP_Gen5_8)."
  default     = "GP_Gen5_2"
}

variable "administrator_login" {
  type        = string
  description = "The administrator login for the PostgreSQL Server."
}

variable "administrator_password" {
  type        = string
  description = "The administrator password for the PostgreSQL Server. If not provided, one will be generated."
  default     = null
}

variable "storage_mb" {
  type        = number
  description = "The max storage size of the PostgreSQL Server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 16777216 MB(16TB) for General Purpose/Memory Optimized SKUs."
  default     = 5120
}

variable "pg_version" {
  type        = string
  description = "The version of the PostgreSQL Server. Valid values are 9.5, 9.6, 10, 10.0, and 11."
  default     = "11"
}

variable "ssl_enforcement_enabled" {
  type        = bool
  description = "Whether SSL enforcement is enabled for the PostgreSQL Server."
  default     = true
}

variable "ssl_minimal_tls_version_enforced" {
  type        = string
  description = "The minimal TLS version enforced by the PostgreSQL Server."
  default     = "TLS1_2"
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether or not public network access is enabled."
  default     = false
}

variable "infrastructure_encryption_enabled" {
  type        = bool
  description = "Should infrastructure encryption be enabled. Defaults to false, as the setting doesn't seem to stay enabled."
  default     = false
}

variable "backup_retention_days" {
  type        = number
  description = "The backup retention days for the PostgreSQL Server. Possible values are between 7 and 35 days."
  default     = 30
}

variable "backup_configuration" {
  description = "Postgresql Databases Data Protection Backup Instances configuration."
  type = object({
    vault_id                                = string
    backup_policy_id                        = string
    database_credential_key_vault_secret_id = string
  })
  default = null
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  description = "Is Geo-Redundant backup enabled on the PostgreSQL Server. Defaults to true."
  default     = true
}

variable "pg_configs" {
  description = "A mapping with the PostgreSQL configurations to apply."
  type        = map(any)
  default     = {}
}

variable "threat_detection_policy" {
  description = "Configure threat detection policy for pg server."
  type        = any
  default     = {}
}

variable "databases" {
  description = "A mapping with the databases to create."
  type = map(object({
    collation = string
    charset   = string
  }))
  default = {}
}

variable "system_assigned_identity" {
  type        = bool
  description = "Whether or not to create a system assigned identity."
  default     = true
}

variable "custom_encryption_enabled" {
  type        = bool
  description = "Whether to use a customer managed key for the PostgreSQL server."
  default     = false
}

variable "customer_managed_key_id" {
  type        = string
  description = "The ID of the Customer Managed Key to use for the PostgreSQL Server."
  default     = null
}

variable "firewall_rules" {
  description = "A map of firewall rules."
  type = map(object({
    start_ip_address = string
    end_ip_address   = string
  }))
  default = {}
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the PostgreSQL server."
  default     = {}
}
