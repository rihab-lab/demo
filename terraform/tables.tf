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

resource "snowflake_table" "raw_metadata" {
  provider = snowflake.sys_admin
  name     = "RAW_METADATA"
  database = snowflake_database.db.name
  schema   = snowflake_schema.raw_layer.name
  comment  = "Table pour ingérer uniquement les métadonnées des fichiers Azure"

  column {
    name = "FILE_NAME"
    type = "VARCHAR"
  }

  column {
    name = "LOAD_DATE"
    type = "DATE"
  }

  column {
    name    = "LOAD_TIME"
    type    = "TIMESTAMP_NTZ"
  }
}