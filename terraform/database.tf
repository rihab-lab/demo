resource "snowflake_database" "db" {
  provider = snowflake.sys_admin
  name     = "Database_POC_VISEO_DB"
  comment  = "Database for Snowflake Terraform demo"
}

# 1) Donne à SYSADMIN les privilèges nécessaires pour créer un schéma dans la base
resource "snowflake_grant_privileges_to_role" "db_usage_for_sysadmin" {
  provider    = snowflake.security_admin
  object_type = "DATABASE"
  object_name = snowflake_database.db.name
  roles       = ["SYSADMIN"]

  privilege = "USAGE"
}

resource "snowflake_grant_privileges_to_role" "db_create_schema_for_sysadmin" {
  provider    = snowflake.security_admin
  object_type = "DATABASE"
  object_name = snowflake_database.db.name
  roles       = ["SYSADMIN"]

  privilege = "CREATE SCHEMA"
}

# 2) Donne au rôle TEST_POC_VISEO_ROLE des privilèges (USAGE, MONITOR, CREATE SCHEMA) sur la base
resource "snowflake_grant_privileges_to_account_role" "database_grant" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE", "MONITOR", "MODIFY", "CREATE SCHEMA"]
  account_role_name = snowflake_account_role.role.name

  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.db.name
  }
}

# 3) Crée le schéma "RAW_LAYER" via SYSADMIN (qui a désormais USAGE + CREATE SCHEMA)
resource "snowflake_schema" "raw_layer" {
  provider            = snowflake.sys_admin
  database            = snowflake_database.db.name
  name                = "RAW_LAYER"
  with_managed_access = false

  depends_on = [
    snowflake_database.db,
    snowflake_grant_privileges_to_role.db_usage_for_sysadmin,
    snowflake_grant_privileges_to_role.db_create_schema_for_sysadmin,
    snowflake_grant_privileges_to_account_role.database_grant
  ]
}

# 4) Donne au rôle TEST_POC_VISEO_ROLE les privilèges nécessaires pour exploiter le schéma RAW_LAYER
resource "snowflake_grant_privileges_to_account_role" "schema_grant_raw" {
  provider          = snowflake.security_admin
  privileges        = [
    "USAGE",
    "CREATE EXTERNAL TABLE",
    "CREATE TABLE",
    "CREATE VIEW",
    "CREATE PROCEDURE",
    "CREATE NOTEBOOK",
    "CREATE STAGE",
    "CREATE FILE FORMAT",
    "CREATE TASK",
    "CREATE STREAM",
    "CREATE PIPE"
  ]
  account_role_name = snowflake_account_role.role.name

  on_schema {
    schema_name = "${snowflake_database.db.name}.${snowflake_schema.raw_layer.name}"
  }
}
