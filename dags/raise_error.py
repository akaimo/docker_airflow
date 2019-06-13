from datetime import datetime

from airflow import DAG
from airflow.operators.python_operator import PythonOperator

args = {"owner": "bob", "start_date": datetime(2019, 6, 1), "retries": 1}

dag = DAG("parametor", default_args=args, catchup=False)


def push_function(**kwargs):
    ls = ["a", datetime.now()]
    return ls


push_task = PythonOperator(
    task_id="push_task", python_callable=push_function, provide_context=True, dag=dag
)


def pull_function(**kwargs):
    ti = kwargs["ti"]
    ls = ti.xcom_pull(task_ids="push_task")
    print(ls)
    raise ValueError('File not parsed completely/correctly')


pull_task = PythonOperator(
    task_id="pull_task", python_callable=pull_function, provide_context=True, dag=dag
)

push_task >> pull_task
