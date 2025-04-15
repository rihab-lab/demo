resource "snowflake_file_format" "csv_file_format" {
  name                         = "MY_CSV_FORMAT"
  database                     = "TEST_POC_VISEO_DB"
  schema                       = "RAW_LAYER"
  format_type                  = "CSV"
  skip_header                  = 1
  field_optionally_enclosed_by = "\""
}
resource "snowflake_stage" "azure_stage" {
  name       = "EXTERNAL_AZURE_STAGE"
  database   = "TEST_POC_VISEO_DB"
  schema     = "RAW_LAYER"
  url        = "azure://storageacctpoc.blob.core.windows.net/landing-zone?sp=r&st=2025-04-15T07:55:24Z&se=2026-06-01T15:55:24Z&spr=https&sv=2024-11-04&sr=c&sig=qdHfIGNdWuBYDiGMR3vguyoNGy5uJb4s5c0I6EUP1Go%3D"
  file_format = snowflake_file_format.csv_file_format.name
}
