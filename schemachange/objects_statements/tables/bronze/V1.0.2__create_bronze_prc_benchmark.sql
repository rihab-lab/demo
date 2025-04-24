CREATE OR REPLACE TABLE BRONZE_LAYER.PRC_BENCHMARK_BRZ
(
  APUKCode VARCHAR not null,
  Anabench2Code VARCHAR not null,
  Anabench2 VARCHAR,
  SKUGroup VARCHAR,
  SYS_SOURCE_DATE VARCHAR,
  CREATE_DATE TIMESTAMP_LTZ COMMENT 'valued with Copy into command metadata',
  file_name VARCHAR COMMENT 'valued with Copy into command metadata',
  PRIMARY KEY(APUKCODE, Anabench2Code)
);