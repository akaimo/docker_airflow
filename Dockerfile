FROM python:3.7

ENV DEBIAN_FRONTEND=noninteractive

# Airflow
ARG AIRFLOW_VERSION=1.10.3
ARG AIRFLOW_HOME=/usr/local/airflow

RUN set -x \
 && apt-get update \
 && buildDeps=' \
     freetds-dev \
     libkrb5-dev \
     libsasl2-dev \
     libssl-dev \
     libffi-dev \
     libpq-dev \
     git \
 ' \
 && apt-get install -y \
     $buildDeps \
     freetds-bin \
     build-essential \
     default-libmysqlclient-dev \
     apt-utils \
     curl \
     rsync \
     netcat \
     locales \
 && sed -i 's/^# ja_JP.UTF-8 UTF-8$/ja_JP.UTF-8 UTF-8/g' /etc/locale.gen \
 && locale-gen \
 && update-locale LANG=ja_JP.UTF-8 LC_ALL=ja_JP.UTF-8 \
 && useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow \
 && pip install -U pip setuptools wheel \
 && pip install pytz \
 && pip install pyOpenSSL \
 && pip install ndg-httpsclient \
 && pip install pyasn1 \
 && pip install apache-airflow[crypto,celery,mysql,ssh]==${AIRFLOW_VERSION} \
 && pip install redis \
 && apt-get purge --auto-remove -y $buildDeps \
 && apt-get autoremove -y --purge \
 && apt-get clean \
 && rm -rf \
     /var/lib/apt/lists/* \
     /tmp/* \
     /var/tmp/* \
     /usr/share/man \
     /usr/share/doc \
     /usr/share/doc-base

COPY airflow.cfg ${AIRFLOW_HOME}/airflow.cfg
COPY entrypoint.sh /entrypoint.sh

RUN chown -R airflow: ${AIRFLOW_HOME}

EXPOSE 8080 5555 8793

USER airflow
WORKDIR ${AIRFLOW_HOME}

ENTRYPOINT ["/entrypoint.sh"]
CMD ["webserver"] # set default arg for entrypoint

