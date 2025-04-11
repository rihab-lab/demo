resource "snowflake_database" "db" {
  name    = "Database_POC_VISEO_DB"
  comment = "Database for Snowflake Terraform demo"
}

resource "snowflake_grant_privileges_to_account_role" "database_grant" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE", "MONITOR", "MODIFY", "CREATE SCHEMA"]
  account_role_name = snowflake_account_role.role.name

  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.db.name
  }
}

resource "snowflake_schema" "raw_layer" {
  provider            = snowflake.sys_admin       // Utilisation du provider sys_admin pour la création du schéma
  database            = snowflake_database.db.name  // Référence à la base créée ci-dessus
  name                = "RAW_LAYER"
  with_managed_access = false

  depends_on = [
    snowflake_database.db,
    snowflake_grant_privileges_to_account_role.database_grant
  ]
}

resource "snowflake_grant_privileges_to_account_role" "schema_grant_raw" {
  provider          = snowflake.security_admin    // Provider pour attribuer les grants sur le schéma
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
    // Construction du nom complet du schéma sous la forme Database.Schema
    schema_name = "${snowflake_database.db.name}.${snowflake_schema.raw_layer.name}"
  }
}
