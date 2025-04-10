resource "snowflake_database" "mon_database" {
  name    = var.database_name
  comment = "Base créée via Terraform"
}
