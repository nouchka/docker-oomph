DOCKER_IMAGE=oomph
VERSIONS=php72 php74

include Makefile.docker

.PHONY: check-version
check-version:
	docker run --rm --entrypoint php $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE):$(VERSION) -v|head -n1| awk '{print $$2}'
	docker run --rm --entrypoint dpkg $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE):$(VERSION) -l| grep jdk|head -n1|awk '{print $$3}'
	docker run --rm --entrypoint composer $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE):$(VERSION) --version| awk '{print $$3}'

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

