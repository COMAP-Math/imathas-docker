# Load environment variables from .env file
include .env
export

# Docker Compose files for environments
DOCKER_COMPOSE_DEVEL = -f docker-compose.yml -f docker-compose-devel.yml
DOCKER_COMPOSE_STAGE = -f docker-compose.yml -f docker-compose-stage.yml
DOCKER_COMPOSE_PROD = -f docker-compose.yml

# Helper commands
DOCKER_COMPOSE = docker-compose
BUILD_ARGS = --build-arg APACHE_SERVER_NAME=$(APACHE_SERVER_NAME) --build-arg TZ=$(TZ) --build-arg APACHE_SERVER_ADMIN=$(APACHE_SERVER_ADMIN)
DOCKER_IMAGE_PRUNE = docker image prune -af || true
DOCKER_STOP = docker-compose $(COMPOSE_FILES) stop > /dev/null 2>&1 || true
DOCKER_UP = docker-compose $(COMPOSE_FILES) up -d
DOCKER_RM = docker-compose $(COMPOSE_FILES) rm -f > /dev/null 2>&1 || true

# General docker compose setup
define DOCKER_COMPOSE_ENV
	$(eval COMPOSE_FILES = $(1))
endef

# Target to build the devel environment
.PHONY: build-devel
build-devel:
	$(eval $(call DOCKER_COMPOSE_ENV,$(DOCKER_COMPOSE_DEVEL)))
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_DEVEL) build $(BUILD_ARGS)

.PHONY: run-devel
run-devel:
	$(eval $(call DOCKER_COMPOSE_ENV,$(DOCKER_COMPOSE_DEVEL)))
	$(DOCKER_STOP)
	$(DOCKER_UP)
	$(DOCKER_RM)
	$(DOCKER_IMAGE_PRUNE)

.PHONY: devel
devel: build-devel run-devel

# Target to build the staging environment
.PHONY: build-staging
build-staging:
	$(eval $(call DOCKER_COMPOSE_ENV,$(DOCKER_COMPOSE_STAGE)))
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_STAGE) build --no-cache $(BUILD_ARGS)

.PHONY: run-staging
run-staging:
	$(eval $(call DOCKER_COMPOSE_ENV,$(DOCKER_COMPOSE_STAGE)))
	$(DOCKER_STOP)
	$(DOCKER_UP)
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_STAGE) run --rm certbot /usr/local/bin/certify-init.sh
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_STAGE) restart app
	$(DOCKER_RM)
	$(DOCKER_IMAGE_PRUNE)

.PHONY: staging
staging: build-staging run-staging

# Target to build the production environment
.PHONY: ssl-production
ssl-production:
	$(eval $(call DOCKER_COMPOSE_ENV,$(DOCKER_COMPOSE_PROD)))
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_PROD) down --remove-orphans
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_PROD) up -d proxy
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_PROD) run --rm certbot /opt/certify-init.sh
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_PROD) restart proxy

.PHONY: build-production
build-production:
	$(eval $(call DOCKER_COMPOSE_ENV,$(DOCKER_COMPOSE_PROD)))
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_PROD) build --no-cache $(BUILD_ARGS)

.PHONY: run-production
run-production:
	$(eval $(call DOCKER_COMPOSE_ENV,$(DOCKER_COMPOSE_PROD)))
	$(DOCKER_STOP)
	$(DOCKER_UP)
	$(DOCKER_RM)
	$(DOCKER_IMAGE_PRUNE)

.PHONY: production
production: ssl-production build-production run-production

.PHONY: clean
clean:
	$(DOCKER_IMAGE_PRUNE)
