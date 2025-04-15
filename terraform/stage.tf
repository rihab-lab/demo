resource "snowflake_file_format" "format" {
  name            = "CSV_FORMAT"
  database        = "TEST_POC_VISEO_DB"    # optional if you want it in a specific DB
  schema          = "RAW_LAYER"            # optional if you want it in a specific schema
  format_type     = "CSV"

  // CSV-specific options
  skip_header                 = 1
  field_optionally_enclosed_by = "\""
}

# 2. Reference this file format in your stage
# Define the stage resource and include the SAS token inline in the URL
resource "snowflake_stage" "azure_stage" {
  name     = "EXTERNAL_AZURE_STAGE"
  database = snowflake_database.db.name
  schema   = snowflake_schema.raw_layer.name

  # Correct URL: Note the prefix is "azure://", followed directly by your account details.
  # DO NOT include "https://" after "azure://"
  url = "azure://storageacctpoc.blob.core.windows.net/landing-zone?sp=r&st=2025-04-15T07:55:24Z&se=2026-06-01T15:55:24Z&spr=https&sv=2024-11-04&sr=c&sig=qdHfIGNdWuBYDiGMR3vguyoNGy5uJb4s5c0I6EUP1Go%3D"
  
  file_format = snowflake_file_format.format.name
} 
