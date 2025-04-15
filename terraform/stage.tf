# 1. Define the file format resource
resource "snowflake_file_format" "csv_file_format" {
  name            = "MY_CSV_FORMAT"
  database        = "TEST_POC_VISEO_DB"    # optional if you want it in a specific DB
  schema          = "RAW_LAYER"            # optional if you want it in a specific schema
  format_type     = "CSV"

  // CSV-specific options
  skip_header                 = 1
  field_optionally_enclosed_by = "\""
}

# 2. Reference this file format in your stage
resource "snowflake_stage" "azure_stage" {
  name       = "EXTERNAL_AZURE_STAGE"
  database   = "TEST_POC_VISEO_DB"
  schema     = "RAW_LAYER"

  // We just pass the file format's name attribute
  file_format        = snowflake_file_format.csv_file_format.name
  storage_integration = "MY_AZURE_INTEGRATION"
  url                = "azure://https://storageacctpoc.blob.core.windows.net/landing-zone?sp=r&st=2025-04-15T07:55:24Z&se=2026-06-01T15:55:24Z&spr=https&sv=2024-11-04&sr=c&sig=qdHfIGNdWuBYDiGMR3vguyoNGy5uJb4s5c0I6EUP1Go%3D"
}
