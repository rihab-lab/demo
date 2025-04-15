resource "snowflake_pipe" "metadata_pipe" {
  provider    = snowflake.sys_admin
  name        = "MY_METADATA_PIPE"
  database = snowflake_database.db.name
  schema   = snowflake_schema.raw_layer.name
  comment     = "Pipe automatique pour ingérer les métadonnées depuis le stage Azure"
  auto_ingest = true

  copy_statement = <<-EOT
    COPY INTO TEST_DB.RAW_LAYER.RAW_METADATA (FILE_NAME, LOAD_DATE)
    FROM (
      SELECT 
        METADATA\$FILENAME AS FILE_NAME,
        TO_DATE(
          REGEXP_SUBSTR(METADATA\$FILENAME, '([0-9]{8})(?=\\.csv)'),
          'YYYYMMDD'
        ) AS LOAD_DATE
      FROM @EXTERNAL_AZUR_STAGE
    )
    FILE_FORMAT = (TYPE = CSV SKIP_HEADER = 1)
    PATTERN = '.*\\.csv'
    ON_ERROR = 'CONTINUE'
  EOT
}