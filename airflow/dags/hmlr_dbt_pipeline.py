from datetime import datetime

from airflow.sdk import DAG
from airflow.providers.standard.operators.bash import BashOperator
from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator



with DAG(
    dag_id="hmlr_dbt_pipeline",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
) as dag:

    trigger_airbyte_task = AirbyteTriggerSyncOperator(
        task_id='trigger_airbyte_connection',
        airbyte_conn_id='airbyte_default',       # Name of the connection configured in Airflow UI
        connection_id='94815121-1e7e-4d36-8800-654e0adce355',   # UUID from your Airbyte connection URL
        asynchronous=False,                       # Set to True if you want to poll with a sensor instead
        timeout=3600,
        wait_seconds=3,
    )

    dbt_build = BashOperator(
        task_id="dbt_build",
        bash_command="""
        cd /Users/tejalgohil/stuff/2026-career/de-project &&
        docker compose run --rm dbt build
        """,
    )

    trigger_airbyte_task >> dbt_build