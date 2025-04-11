resource "snowflake_database" "demo_db" {
  name    = "TEST_POC_VISEO_DB"
  comment = "Database for Snowflake Terraform demo"
}
