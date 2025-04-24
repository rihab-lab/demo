CREATE OR REPLACE TABLE GOLD_LAYER.DIM_PRC_CAMPAIGN_GLD (
  PrcPcsCampaignIntKey           NUMBER                 NOT NULL PRIMARY KEY,
  HouseKey                       VARCHAR                NOT NULL,
  CampaignCode                   VARCHAR                NOT NULL,
  CampaignName                   VARCHAR,
  CampaignDescription            VARCHAR,
  HistoricalSellInFirstMonth     VARCHAR,
  HistoricalSellInLastMonth      VARCHAR,
  CampaignDate                   DATE,
  SYS_DATE_CREATE                TIMESTAMP_LTZ          NOT NULL,
  SYS_DATE_UPDATE                TIMESTAMP_LTZ          NOT NULL
);