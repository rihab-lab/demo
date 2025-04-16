resource "snowflake_table" "change_history_table" {
  provider = snowflake.sys_admin
  database = snowflake_database.db.name
  schema   = snowflake_schema.monitoring_layer.name
  name     = "CHANGE_HISTORY"
  comment  = "Schemachange history table"

  column {
    name     = "VERSION"
    type     = "VARCHAR"
    nullable = true

  }
  column {
    name     = "DESCRIPTION"
    type     = "VARCHAR"
    nullable = true

  }
  column {
    name     = "SCRIPT"
    type     = "VARCHAR"
    nullable = true

  }
  column {
    name     = "SCRIPT_TYPE"
    type     = "VARCHAR"
    nullable = true

  }
  column {
    name     = "CHECKSUM"
    type     = "VARCHAR"
    nullable = true

  }
  column {
    name     = "EXECUTION_TIME"
    type     = "NUMBER"
    nullable = true

  }

  column {
    name     = "STATUS"
    type     = "VARCHAR"
    nullable = true

  }
  column {
    name     = "INSTALLED_BY"
    type     = "VARCHAR"
    nullable = true

  }

  column {
    name = "INSTALLED_ON"
    type = "TIMESTAMP_LTZ"
  }

}


resource "snowflake_table" "prc_benchmark_raw" {
  provider = snowflake.sys_admin
  name     = "RAW_PRC_BENCHMARK"
  database = snowflake_database.db.name
  schema   = snowflake_schema.raw_layer.name

  column {
    name = "APUKCode"
    type = "VARCHAR"
  }
  column {
    name = "Anabench2Code"
    type = "VARCHAR"
  }
  column {
    name = "Anabench2"
    type = "VARCHAR"
  }
  column {
    name = "SKUGroup"
    type = "VARCHAR"
  }
  column {
    name = "SYS_SOURCE_DATE"
    type = "DATE"
  }
  column {
  name = "FILE_NAME"
  type = "STRING"
}

  column {
  name = "LOAD_TIME"
  type = "TIMESTAMP_NTZ"
}

}

resource "snowflake_table" "prc_campaign_raw" {
  provider = snowflake.sys_admin
  name     = "RAW_PRC_CAMPAIGN"
  database = snowflake_database.db.name
  schema   = snowflake_schema.raw_layer.name

  column {
    name = "APUKCode"
    type = "VARCHAR"
  }
  column {
    name = "Anabench2Code"
    type = "VARCHAR"
  }
  column {
    name = "Anabench2"
    type = "VARCHAR"
  }
  column {
    name = "SKUGroup"
    type = "VARCHAR"
  }
  column {
    name = "SYS_SOURCE_DATE"
    type = "DATE"
  }
  column {
    name = "CampaignDate"
    type = "DATE"
  }
  column {
    name = "SYS_SOURCE_DATE_2"
    type = "DATE"
  }
  column {
  name = "FILE_NAME"
  type = "STRING"
}

  column {
  name = "LOAD_TIME"
  type = "TIMESTAMP_NTZ"
}

}
