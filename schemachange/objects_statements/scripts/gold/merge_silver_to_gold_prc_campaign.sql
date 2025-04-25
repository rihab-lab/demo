MERGE INTO GOLD_LAYER.DIM_PRC_CAMPAIGN_GLD AS tgt
USING (
  SELECT
    PricingCampaignPrcIntKey    AS PrcPcsCampaignIntKey,
    HouseKey,
    CampaignCode,
    CURRENT_TIMESTAMP()         AS SYS_DATE_CREATE,
    CURRENT_TIMESTAMP()         AS SYS_DATE_UPDATE
  --FROM SILVER_LAYER.DIM_PRC_CAMPAIGN_SLV
  FROM SILVER_LAYER.DIM_PRC_CAMPAIGN_SLV_STREAM
  WHERE PricingCampaignPrcIntKey IS NOT NULL
    AND HouseKey                  IS NOT NULL
    AND CampaignCode              IS NOT NULL
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
