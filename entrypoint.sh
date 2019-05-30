#!/usr/bin/env bash

export AIRFLOW__CORE__FERNET_KEY=QY3C8naPIFquXNBAmdD_hbuDImKxzcoP5r1Ylnr7oVA=

case "$1" in
  webserver)
    airflow initdb
    exec airflow webserver
    ;;
  worker|scheduler)
    # To give the webserver time to run initdb.
    sleep 10
    exec airflow "$@"
    ;;
  flower)
    sleep 10
    exec airflow "$@"
    ;;
  version)
    exec airflow "$@"
    ;;
  *)
    # The command is something like bash, not an airflow subcommand. Just run it in the right environment.
    exec "$@"
    ;;
esac
