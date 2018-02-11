.DEFAULT_GOAL := build

build:
	docker-compose build

test: build
	docker-compose up -d

