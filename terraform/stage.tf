
resource "snowflake_file_format" "CSV_file_format" {
  provider  = snowflake.sys_admin
  name      = "CSV_FORMAT"
  database = snowflake_database.db.name
  schema   = snowflake_schema.raw_layer.name          # optional if you want it in a specific schema
  format_type     = "CSV"

  // CSV-specific options
  skip_header                 = 1
  field_optionally_enclosed_by = "\""
}
resource "snowflake_stage" "azure_external_stage" {
  provider  = snowflake.sys_admin
  name     = "EXTERNAL_AZUR_STAGE"
  database = snowflake_database.db.name
  schema   =  "RAW_LAYER"
  url      = "azure://storageacctpoc.blob.core.windows.net/landing-zone"

  credentials = jsonencode({
    AZURE_SAS_TOKEN = var.sas_token
  })

  file_format = snowflake_file_format.CSV_file_format.name
}
