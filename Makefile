.DEFAULT_GOAL := build

build:
	docker-compose build

test: build
	docker-compose up -d

clean:
	docker rmi nouchka/oomph
	docker-compose down -v

