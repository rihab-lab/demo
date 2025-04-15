
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
resource "snowflake_sql" "create_azure_stage" {
  provider = snowflake.sys_admin

  database = snowflake_database.db.name
  warehouse = "YOUR_WAREHOUSE" # optionnel mais utile
  statement = <<EOT
    CREATE OR REPLACE STAGE RAW_LAYER.EXTERNAL_AZUR_STAGE
    URL = 'azure://storageacctpoc.blob.core.windows.net/landing-zone'
    CREDENTIALS = (AZURE_SAS_TOKEN='${var.sas_token}')
    FILE_FORMAT = CSV_FORMAT;
  EOT
}