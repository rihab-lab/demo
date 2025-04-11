resource "snowflake_database" "demo_db" {
  name    = "DEV_POC_VISEO_DB"
  comment = "Database for Snowflake Terraform demo"
}

resource "snowflake_grant_privileges_to_account_role" "database_grant" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE", "MONITOR", "MODIFY", "CREATE SCHEMA"]
  account_role_name = snowflake_account_role.role.name
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.demo_db.name
  }
}

resource "snowflake_schema" "raw_layer" {
  provider            = snowflake.sys_admin       // Utilise le provider aliasé "sys_admin"
  database            = snowflake_database.demo_db.name  // La base de données à laquelle se rattache le schéma
  name                = "RAW_LAYER"
  with_managed_access = false
  
  depends_on = [
    snowflake_database.demo_db,
    snowflake_grant_privileges_to_account_role.database_grant
  ]
}


resource "snowflake_grant_privileges_to_account_role" "schema_grant_raw" {
  provider          = snowflake.security_admin    // Utilise le provider aliasé "security_admin"
  privileges        = ["USAGE", "CREATE EXTERNAL TABLE", "CREATE TABLE", "CREATE VIEW", "CREATE PROCEDURE", "CREATE NOTEBOOK", "CREATE STAGE", "CREATE FILE FORMAT", "CREATE TASK", "CREATE STREAM", "CREATE PIPE"]
  account_role_name = snowflake_account_role.role.name  // Nom du rôle auquel accorder les privilèges
  
  on_schema {
    // Construction du nom complet du schéma : "DATABASE"."SCHEMA"
    schema_name = "\"${snowflake_database.demo_db.name}\".\"${snowflake_schema.raw_layer.name}\""
  }
}
