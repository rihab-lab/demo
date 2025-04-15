
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
resource "null_resource" "create_stage_sql" {
  provisioner "local-exec" {
    command = <<EOT
snowsql -a $SNOWFLAKE_ACCOUNT \
        -u $SNOWFLAKE_USER \
        -p $SNOWFLAKE_PASSWORD \
        -r SYSADMIN \
        -d TEST_POC_VISEO_DB \
        -s RAW_LAYER \
        -q "CREATE OR REPLACE STAGE RAW_LAYER.EXTERNAL_AZUR_STAGE
            URL = 'azure://storageacctpoc.blob.core.windows.net/landing-zone'
            CREDENTIALS = (AZURE_SAS_TOKEN='$TF_VAR_sas_token')
            FILE_FORMAT = CSV_FORMAT;"
EOT
  }
}


