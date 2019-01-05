.DEFAULT_GOAL := build

build:
	chmod +x ./hooks/build
	export DOCKER_TAG=php7;export IMAGE_NAME="nouchka/oomph:php7"; ./hooks/build

build-all: build
	export DOCKER_TAG=php5;export IMAGE_NAME="nouchka/oomph:php5"; ./hooks/build
	export DOCKER_TAG=latest;export IMAGE_NAME="nouchka/oomph:latest"; ./hooks/build

test: build
	docker-compose up -d

down:
	##docker rmi nouchka/oomph
	docker-compose down -v

test-dockerapp:
	@$(eval CURRENT_USER = $(shell whoami))
	@mkdir -p /home/$(CURRENT_USER)/.eclipse/eclipses/ /home/$(CURRENT_USER)/.eclipse/installer/ /home/$(CURRENT_USER)/.eclipse/workspaces/ /home/$(CURRENT_USER)/.eclipse/plugins/
	@docker volume create --name eclipse_setups -o type=none -o device=/home/$(CURRENT_USER)/.eclipse/eclipses/ -o o=bind
	@docker volume create --name eclipse_installer -o type=none -o device=/home/$(CURRENT_USER)/.eclipse/installer/ -o o=bind
	@docker volume create --name eclipse_workspace -o type=none -o device=/home/$(CURRENT_USER)/.eclipse/workspaces/ -o o=bind
	@docker volume create --name eclipse_plugins -o type=none -o device=/home/$(CURRENT_USER)/.eclipse/plugins/ -o o=bind
	docker volume create --name test_volume -o type=none -o device=/tmp/ -o o=bind
	docker-app render --set USER=$(CURRENT_USER)
	sleep 10
	docker-app render --set USER=$(CURRENT_USER)| docker-compose -f - up
	docker-app render --set USER=$(CURRENT_USER)| docker-compose down -v
	docker volume rm test_volume

