IF SYSTEM$STREAM_HAS_DATA('SILVER_LAYER.DIM_PRC_BENCHMARK_SLV_STREAM') THEN
MERGE INTO GOLD_LAYER.DIM_PRC_BENCHMARK_GLD AS tgt
USING (
  SELECT
    PRICINGBENCHMARKPRCINTKEY         AS PrcPcsBenchmarkIntKey,
    -- Valeur par défaut pour la colonne non présente en SILVER
    0                                  AS PrcPcsGenericProductIntKey,
    APUKCODE,
    CURRENT_TIMESTAMP()               AS SYS_DATE_CREATE,
    CURRENT_TIMESTAMP()               AS SYS_DATE_UPDATE
  --FROM SILVER_LAYER.DIM_PRC_BENCHMARK_SLV
  FROM SILVER_LAYER.DIM_PRC_BENCHMARK_SLV_STREAM
  WHERE PRICINGBENCHMARKPRCINTKEY IS NOT NULL
    AND APUKCODE                   IS NOT NULL
) src
ON tgt.PrcPcsBenchmarkIntKey = src.PrcPcsBenchmarkIntKey

WHEN MATCHED THEN UPDATE SET
  PrcPcsGenericProductIntKey = src.PrcPcsGenericProductIntKey,
  APUKCODE                   = src.APUKCODE,
  SYS_DATE_UPDATE            = CURRENT_TIMESTAMP()

WHEN NOT MATCHED THEN INSERT (
  PrcPcsBenchmarkIntKey,
  PrcPcsGenericProductIntKey,
  APUKCODE,
  SYS_DATE_CREATE,
  SYS_DATE_UPDATE
) VALUES (
  src.PrcPcsBenchmarkIntKey,
  src.PrcPcsGenericProductIntKey,
  src.APUKCODE,
  src.SYS_DATE_CREATE,
  src.SYS_DATE_UPDATE
);