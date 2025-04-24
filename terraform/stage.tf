/*resource "snowflake_storage_integration" "azure_int" {
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

resource "snowflake_stage" "azure_stage" {
  provider            = snowflake.account_admin
  name                = "EXTERNAL_AZURE_STAGE"
  database            = "TEST_POC_VISEO_DB"
  schema              = "RAW_LAYER"
  url                 = var.azure_container_url
  storage_integration = snowflake_storage_integration.azure_int.name

  file_format = <<-EOT
    TYPE = CSV
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  EOT
}*/