CREATE OR REPLACE STREAM RAW_LAYER.PRC_BENCHMARK_RAW_STREAM
  ON TABLE RAW_LAYER.PRC_BENCHMARK_RAW
  SHOW_INITIAL_ROWS = FALSE;