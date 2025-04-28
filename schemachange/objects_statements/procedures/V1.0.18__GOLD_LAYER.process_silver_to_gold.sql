CREATE OR REPLACE PROCEDURE GOLD_LAYER.process_silver_to_gold()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
-- From: merge_silver_to_gold_prc_benchmark.sql
--update code
MERGE INTO GOLD_LAYER.DIM_PRC_BENCHMARK_GLD AS tgt
USING (
  SELECT *
  FROM (
    SELECT
      PRICINGBENCHMARKPRCINTKEY         AS PrcPcsBenchmarkIntKey,
      0                                 AS PrcPcsGenericProductIntKey,
      APUKCODE,
      CURRENT_TIMESTAMP()               AS SYS_DATE_CREATE,
      CURRENT_TIMESTAMP()               AS SYS_DATE_UPDATE,
      ROW_NUMBER() OVER (
        PARTITION BY PRICINGBENCHMARKPRCINTKEY
        ORDER BY SYS_DATE_UPDATE DESC
      ) AS row_num
    FROM SILVER_LAYER.DIM_PRC_BENCHMARK_SLV_STREAM
    WHERE PRICINGBENCHMARKPRCINTKEY IS NOT NULL
      AND APUKCODE IS NOT NULL
  )
  WHERE row_num = 1
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

-- From: merge_silver_to_gold_prc_campaign.sql
--update code
MERGE INTO GOLD_LAYER.DIM_PRC_CAMPAIGN_GLD AS tgt
USING (
  SELECT *
  FROM (
    SELECT
      PricingCampaignPrcIntKey    AS PrcPcsCampaignIntKey,
      HouseKey,
      CampaignCode,
      CURRENT_TIMESTAMP()         AS SYS_DATE_CREATE,
      CURRENT_TIMESTAMP()         AS SYS_DATE_UPDATE,
      ROW_NUMBER() OVER (
        PARTITION BY PricingCampaignPrcIntKey
        ORDER BY SYS_DATE_UPDATE DESC
      ) AS row_num
    FROM SILVER_LAYER.DIM_PRC_CAMPAIGN_SLV_STREAM
    WHERE PricingCampaignPrcIntKey IS NOT NULL
      AND HouseKey                  IS NOT NULL
      AND CampaignCode              IS NOT NULL
  )
  WHERE row_num = 1
) src
ON tgt.PrcPcsCampaignIntKey = src.PrcPcsCampaignIntKey

WHEN MATCHED THEN UPDATE SET
  HouseKey        = src.HouseKey,
  CampaignCode    = src.CampaignCode,
  SYS_DATE_UPDATE = CURRENT_TIMESTAMP()

WHEN NOT MATCHED THEN INSERT (
  PrcPcsCampaignIntKey,
  HouseKey,
  CampaignCode,
  SYS_DATE_CREATE,
  SYS_DATE_UPDATE
) VALUES (
  src.PrcPcsCampaignIntKey,
  src.HouseKey,
  src.CampaignCode,
  src.SYS_DATE_CREATE,
  src.SYS_DATE_UPDATE
);


  RETURN 'GOLD_LAYER.process_silver_to_gold terminé';
END;
$$;
