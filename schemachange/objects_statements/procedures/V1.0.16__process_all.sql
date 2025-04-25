CREATE OR REPLACE PROCEDURE GOLD_LAYER.process_all()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
  CALL bronze_layer.ingest_all_streams_py();
  CALL SILVER_LAYER.process_bronze_to_silver();
  CALL GOLD_LAYER.process_silver_to_gold();
  RETURN 'Pipeline RAW → BRONZE → SILVER → GOLD terminé';
END;
$$;
