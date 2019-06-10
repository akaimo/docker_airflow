up:
	docker-compose build
	docker-compose up -d

stop:
	docker-compose stop

rm:
	docker-compose down

build:
	docker build -t airflow .
