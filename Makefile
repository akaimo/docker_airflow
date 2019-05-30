up:
	docker-compose build
	docker-compose up -d

build:
	docker build -t airflow .
