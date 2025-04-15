# File Format
################################
resource "snowflake_file_format" "format" {
  provider  = snowflake.sys_admin
  name      = "CSV_FORMAT"
  database  = snowflake_database.db.name       # "TEST_POC_VISEO_DB"
  schema    = snowflake_schema.raw_layer.name  # "RAW_LAYER"
  format_type     = "CSV"

  # CSV-specific options
  skip_header                  = 1
  field_optionally_enclosed_by = "\""
}

################################
# Stage
################################
resource "snowflake_stage" "azure_stage" {
  provider  = snowflake.sys_admin
  name      = "EXTERNAL_AZURE_STAGE"
  database  = snowflake_database.db.name
  schema    = snowflake_schema.raw_layer.name

  url        = "azure://storageacctpoc.blob.core.windows.net/landing-zone?sp=r&st=2025-04-15T07:55:24Z&se=2026-06-01T15:55:24Z&spr=https&sv=2024-11-04&sr=c&sig=xxx"

  # Référence le file format défini plus haut
  file_format = "\"TEST_POC_VISEO_DB\".\"RAW_LAYER\".\"CSV_FORMAT\""

 
}
