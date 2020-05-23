.DEFAULT_GOAL := build

VERSIONS=php5 php7 php72 php73 php74

build-version:
	chmod +x ./hooks/build
	export DOCKER_TAG=$(VERSION);export IMAGE_NAME="nouchka/oomph:$(VERSION)"; ./hooks/build

build:
	$(foreach version,$(VERSIONS), $(MAKE) -s build-version VERSION=$(version);)
	$(MAKE) -s build-version VERSION=latest

build-latest:
	$(MAKE) -s build-version VERSION=latest

check-version:
	echo $(VERSION)
	docker run --rm nouchka/oomph:$(VERSION) php -v|head -n1
	docker run --rm nouchka/oomph:$(VERSION) java -version|head -n1
	docker run --rm nouchka/oomph:$(VERSION) composer --version

check:
	$(foreach version,$(VERSIONS), $(MAKE) -s check-version VERSION=$(version);)
	$(MAKE) -s check-version VERSION=latest

test: build-latest
	docker-compose up -d

down:
	##docker rmi nouchka/oomph
	docker-compose down -v

test-dockerapp:
	make build VERSION=$(VERSION)
	@$(eval CURRENT_USER = $(shell whoami))
	@mkdir -p /home/$(CURRENT_USER)/.eclipse/eclipses/ /home/$(CURRENT_USER)/.eclipse/installer/ /home/$(CURRENT_USER)/.eclipse/workspaces/ /home/$(CURRENT_USER)/.eclipse/plugins/
	@docker volume create --name eclipse_setups -o type=none -o device=/home/$(CURRENT_USER)/.eclipse/eclipses/ -o o=bind
	@docker volume create --name eclipse_installer -o type=none -o device=/home/$(CURRENT_USER)/.eclipse/installer/ -o o=bind
	@docker volume create --name eclipse_workspace -o type=none -o device=/home/$(CURRENT_USER)/.eclipse/workspaces/ -o o=bind
	@docker volume create --name eclipse_plugins -o type=none -o device=/home/$(CURRENT_USER)/.eclipse/plugins/ -o o=bind
	docker volume create --name test_volume -o type=none -o device=/tmp/ -o o=bind
	docker-app render --set USER=$(CURRENT_USER) --set IMAGE_VERSION=$(VERSION)
	sleep 10
	docker-app render --set USER=$(CURRENT_USER) --set IMAGE_VERSION=$(VERSION)| docker-compose -f - up
	docker-app render --set USER=$(CURRENT_USER) --set IMAGE_VERSION=$(VERSION)| docker-compose down -v
	docker volume rm test_volume

