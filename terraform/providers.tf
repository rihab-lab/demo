provider "snowflake" {
  account  = var.snowflake_account     # exemple : "GL28585.gcp_europe_west4"
  username = var.snowflake_username    # ex : "RIHABBAHRI"
  password = var.snowflake_password    # sensible
  role     = "SYSADMIN"

  preview_features_enabled = ["snowflake_table_resource"]
}
