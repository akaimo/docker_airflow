from datetime import datetime

import requests
from airflow import DAG
from airflow.operators.python_operator import PythonOperator

args = {"owner": "airflow", "retry": 1}

dag = DAG(
    "requests", start_date=datetime(2019, 6, 10), default_args=args, catchup=False
)


def api():
    url = "https://www.google.com"
    respose = requests.get(url)
    print(respose)


t1 = PythonOperator(task_id="requests", dag=dag, python_callable=api)
