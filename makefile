# import config.
# You can change the default config with `make cnf="config_special.env" up`
cnf ?= .env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

up: run open-port ## Start mtproto-proxy.
	@docker logs $(NAME) 2>/dev/null | sed 's/port=443/port=$(PORT)/'

down: stop close-port remove ## Stop mtproto-proxy.
	@echo "Done"

run: ## Run container.
	docker run -d --restart=always -p$(PORT):443 --name=$(NAME) -e SECRET=$(SECRET) telegrammessenger/proxy:latest

stop: ## Stop container.
	docker stop $(NAME)

remove: stop ## Remove container.
	docker rm $(NAME)

secret: ## Generate a secret.
	@tr -cd a-z0-9 < /dev/urandom | fold -w32 | head -n1

dd-secret: ## Generate a secret (with random padding). https://github.com/TelegramMessenger/MTProxy#random-padding
	@echo dd$(shell tr -cd a-z0-9 < /dev/urandom | fold -w30 | head -n1)

logs: ## Show logs from container.
	docker logs $(NAME) -f

in-bash: ## Start and attach new bash shell in container.
	@docker exec -ti $(NAME) /bin/bash

open-port: ## Open port in firewall.
	@echo "Open port in firewall"
	@sudo firewall-cmd --zone=public --add-port=$(PORT)/tcp --permanent
	@sudo firewall-cmd --reload 1>/dev/null

close-port: ## Close port in firewall.
	@echo "Close port in firewall"
	@sudo firewall-cmd --zone=public --remove-port=$(PORT)/tcp --permanent
	@sudo firewall-cmd --reload 1>/dev/null
