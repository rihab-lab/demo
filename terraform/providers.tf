provider "snowflake" {
  account                  = var.snowflake_account
  username                 = var.snowflake_username
  password                 = var.snowflake_password
  role                     = "SYSADMIN"
  region                   = var.snowflake_region
  preview_features_enabled = ["snowflake_table_resource"]
}
