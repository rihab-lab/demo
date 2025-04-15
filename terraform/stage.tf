#################################################
# File Format
#################################################
resource "snowflake_file_format" "format" {
  provider  = snowflake.sys_admin
  name      = "CSV_FORMAT"
  database  = snowflake_database.db.name       # e.g., "TEST_POC_VISEO_DB"
  schema    = snowflake_schema.raw_layer.name  # e.g., "RAW_LAYER"
  format_type = "CSV"

  skip_header                  = 1
  field_optionally_enclosed_by = "\""
}

#################################################
# Stage
#################################################
resource "snowflake_stage" "azure_stage" {
  provider = snowflake.sys_admin
  name     = "EXTERNAL_AZURE_STAGE"
  database = snowflake_database.db.name
  schema   = snowflake_schema.raw_layer.name

  # Fully qualified SAS URL
  url = "azure://storageacctpoc.blob.core.windows.net/landing-zone?sp=r&st=2025-04-15T07:55:24Z&se=2026-06-01T15:55:24Z&spr=https&sv=2024-11-04&sr=c&sig=qdHfIGNdWuBYDiGMR3vguyoNGy5uJb4s5c0I6EUP1Go%3D"

  # Best practice: reference the resource instead of a plain string
  file_format = "${snowflake_file_format.format.name}"
}
