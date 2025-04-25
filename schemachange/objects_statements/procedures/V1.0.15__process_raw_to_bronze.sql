CREATE OR REPLACE PROCEDURE bronze_layer.ingest_all_streams_py()
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.8'
  PACKAGES = ('snowflake-snowpark-python')
  HANDLER = 'main'
AS
$$
from snowflake.snowpark import Session
from snowflake.snowpark.functions import col

def main(session: Session) -> str:
    # 1) Lister tous les streams RAW_LAYER.*_STREAM
    streams = session.sql("SHOW STREAMS IN SCHEMA RAW_LAYER").collect()

    for s in streams:
        name = s['name']  # ex. "PRC_BENCHMARK_RAW_STREAM"
        if not name.endswith('_STREAM'):
            continue

        # on retire "_STREAM"
        prefix_with_raw = name[:-7]           # ex. "PRC_BENCHMARK_RAW"
        # la table RAW existe sans double "_RAW"
        raw_table    = f"RAW_LAYER.{prefix_with_raw}"
        # pour la couche Bronze, on enlève le suffixe "_RAW" puis on ajoute "_BRZ"
        bronze_base  = prefix_with_raw[:-4]   # ex. "PRC_BENCHMARK"
        bronze_table = f"BRONZE_LAYER.{bronze_base}_BRZ"

        monitor_tbl  = "TEST_POC_VISEO_DB.MONITORING_LAYER.TRACKERS"
        stream_table = f"RAW_LAYER.{name}"

        # 2) Récupérer distinct file_name & load_time
        df = (
            session.table(stream_table)
                   .select(col("file_name"), col("load_time"))
                   .distinct()
        )
        for row in df.collect():
            file_name = row[0]
            load_time = row[1].isoformat()

            # 3) Charger en Bronze
            session.sql(f"""
                INSERT INTO {bronze_table}
                SELECT
                  t.* EXCLUDE (file_name, load_time),
                  t.load_time AS CREATE_DATE,
                  t.file_name AS FILE_NAME
                FROM {raw_table} t
                WHERE t.file_name = '{file_name}'
                  AND t.load_time = TO_TIMESTAMP_LTZ('{load_time}')
            """).collect()

            # 4) Tracer dans la table centralisée
            session.sql(f"""
                INSERT INTO {monitor_tbl}
                  (source_flux, file_name, load_time, processed_at, status, error_message)
                VALUES (
                  '{bronze_base}',
                  '{file_name}',
                  TO_TIMESTAMP_LTZ('{load_time}'),
                  CURRENT_TIMESTAMP(),
                  'SUCCESS',
                  NULL
                )
            """).collect()

    return "OK"
$$;
