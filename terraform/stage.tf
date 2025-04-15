resource "snowflake_file_format" "CSV_file_format" {
  provider  = snowflake.sys_admin
  name      = "CSV_FORMAT"
  database  = snowflake_database.db.name
  schema    = snowflake_schema.raw_layer.name
  format_type = "CSV"

  skip_header                   = 1
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
            CREDENTIALS = (AZURE_SAS_TOKEN='$SAS_TOKEN')
            FILE_FORMAT = CSV_FORMAT;"
EOT
    environment = {
      SAS_TOKEN = var.sas_token
    }
  }
}
