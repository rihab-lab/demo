provider "snowflake" {
  alias                    = "security_admin"
  role                     = "SECURITYADMIN"
  preview_features_enabled = ["snowflake_table_resource"] 
 
}

provider "snowflake" {
  alias                    = "sys_admin"
  role                     = "SYSADMIN"
  preview_features_enabled = ["snowflake_table_resource"] 
}
