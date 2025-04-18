CREATE TABLE IF NOT EXISTS TEST_POC_VISEO_DB.MONITORING_LAYER.TRACKERS (
  source_flux   STRING,
  file_name     STRING,
  load_time     TIMESTAMP_LTZ,
  processed_at  TIMESTAMP_LTZ,
  status        STRING,
  error_message STRING
);