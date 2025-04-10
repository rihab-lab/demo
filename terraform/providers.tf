provider "snowflake" {
  alias                    = "security_admin"
  role                     = "SECURITYADMIN"
  preview_features_enabled = ["snowflake_table_resource"] # mandatory to use preview resource "table creation"
  //   profile  = "securityadmin"
}

provider "snowflake" {
  alias                    = "sys_admin"
  role                     = "SYSADMIN"
  preview_features_enabled = ["snowflake_table_resource"] # mandatory to use preview resource "table creation"
}

provider "snowflake" {
  alias                    = "account_admin"
  role                     = "ACCOUNTADMIN"
  preview_features_enabled = ["snowflake_table_resource"] # mandatory to use preview resource "table creation"
}