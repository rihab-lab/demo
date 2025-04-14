# 3. Création du stage externe pointant vers Azure Blob Storage
############################################
resource "snowflake_stage" "azure_stage" {
  provider = snowflake.sys_admin
  name     = "EXTERNAL_AZUR_STAGE"
  database = "TEST_POC_VISEO_DB"
  schema   = "RAW_LAYER"

  # Utiliser une Storage Integration pour un accès sécurisé (ou configurez un SAS Token)
  storage_integration = "MY_AZURE_INTEGRATION"
  url                 = "azure://https://storageacctpoc.blob.core.windows.net/landing-zone?sp=r&st=2025-04-14T14:24:14Z&se=2026-05-31T22:24:14Z&spr=https&sv=2024-11-04&sr=c&sig=11kg7mVlvlCc%2BzXXfOoVr43sa7zXNjuKRHVncl8EwQQ%3D"
  
  file_format {
    type                        = "CSV"
    skip_header                 = 1
    field_optionally_enclosed_by = "\""
  }
}