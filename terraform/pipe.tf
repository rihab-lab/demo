resource "snowflake_pipe" "pipe_raw_prc_benchmark" {
  name     = "PIPE_RAW_PRC_BENCHMARK"
  provider = snowflake.account_admin
  database = "TEST_POC_VISEO_DB"
  schema   = "RAW_LAYER"

  copy_statement = <<-SQL
   COPY INTO TEST_POC_VISEO_DB.RAW_LAYER.RAW_PRC_BENCHMARK (
  "APUKCode",
  "Anabench2Code",
  "Anabench2",
  "SKUGroup",
   SYS_SOURCE_DATE,
   FILE_NAME,
   LOAD_TIME
)
FROM (
  SELECT
    $1,                         -- APUKCode
    $2,                         -- Anabench2Code
    $3,                         -- Anabench2
    $4,                         -- SKUGroup
    $5,
    METADATA$FILENAME,         -- FILE_NAME
    CURRENT_TIMESTAMP()        -- LOAD_TIME
  FROM @TEST_POC_VISEO_DB.RAW_LAYER.EXTERNAL_AZUR_STAGE
)
FILE_FORMAT = (
  TYPE = 'CSV'
  FIELD_DELIMITER = ';'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1
)
PATTERN = '.*PRC_BENCHMARK_[0-9]{8}\\.csv';
  SQL
}
