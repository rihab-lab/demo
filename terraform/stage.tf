resource "snowflake_storage_integration" "azure_int" {
  provider              = snowflake.account_admin
  name                   = "AZURE_STORAGE_INT"
  type                   = "EXTERNAL_STAGE"
  storage_provider       = "AZURE"
  azure_tenant_id        = var.azure_tenant_id
  storage_allowed_locations = [
    var.azure_container_url
  ]
  enabled = true
}

resource "snowflake_file_format" "csv_format" {
  provider              = snowflake.account_admin
  name        = "CSV_FORMAT"
  database    = "TEST_POC_VISEO_DB"
  schema      = "RAW_LAYER"
  format_type = "CSV"

  skip_header                   = 1
  field_optionally_enclosed_by = "\""
}

resource "snowflake_stage" "azure_stage" {
  provider            = snowflake.account_admin
  name                = "EXTERNAL_AZURE_STAGE"
  database            = "TEST_POC_VISEO_DB"
  schema              = "RAW_LAYER"
  url                 =  var.azure_container_url
  storage_integration = "AZURE_STORAGE_INT"

  file_format = "FORMAT_NAME = TEST_POC_VISEO_DB.RAW_LAYER.CSV_FORMAT"
}
