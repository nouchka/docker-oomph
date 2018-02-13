.DEFAULT_GOAL := build

build:
	chmod +x ./hooks/build
	export DOCKER_TAG=latest;export IMAGE_NAME="nouchka/oomph:latest"; ./hooks/build

build-all: build
	export DOCKER_TAG=php5;export IMAGE_NAME="nouchka/oomph:php5"; ./hooks/build
	export DOCKER_TAG=php7;export IMAGE_NAME="nouchka/oomph:php7"; ./hooks/build

test: build
	docker-compose up -d

clean:
	docker rmi nouchka/oomph
	docker-compose down -v

