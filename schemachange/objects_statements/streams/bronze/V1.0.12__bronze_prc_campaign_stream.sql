CREATE OR REPLACE STREAM BRONZE_LAYER.PRC_CAMPAIGN_BRZ_STREAM
  ON TABLE BRONZE_LAYER.PRC_CAMPAIGN_BRZ
  SHOW_INITIAL_ROWS = FALSE;