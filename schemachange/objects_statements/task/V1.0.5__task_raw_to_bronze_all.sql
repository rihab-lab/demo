CREATE OR REPLACE TASK RAW_TO_BRONZE_ALL
  WAREHOUSE = TEST_WH
  SCHEDULE  = 'USING CRON */5 * * * * UTC'
AS
CALL bronze_layer.ingest_all_streams_py();
