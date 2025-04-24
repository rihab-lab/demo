CREATE OR REPLACE PROCEDURE process_all()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
  CALL process_raw_to_bronze();
  CALL process_bronze_to_silver();
  CALL process_silver_to_gold();
  RETURN 'Pipeline RAW → BRONZE → SILVER → GOLD terminé';
END;
$$;
