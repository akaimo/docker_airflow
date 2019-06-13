from datetime import datetime

from airflow import DAG
from airflow.operators.python_operator import PythonOperator

import func

args = {"orner": "master", "start_date": datetime(2019, 6, 1), "retries": 1}

dag = DAG("call_func", default_args=args, catchup=False)


def call():
    func.sample_func()


task = PythonOperator(task_id="call", python_callable=call, dag=dag)
