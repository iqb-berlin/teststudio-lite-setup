run:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up
run-detached:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
stop:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml stop

run-prod:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml up
run-prod-detached:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
stop-prod:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml stop

run-prod-tls:
	docker-compose -f docker-compose.yml -f docker-compose.prod.nontls.yml -f docker-compose.prod.tls.yml up
run-prod-tls-detached:
	docker-compose -f docker-compose.yml -f docker-compose.prod.nontls.yml -f docker-compose.prod.tls.yml up -d
stop-prod-tls:
	docker-compose -f docker-compose.yml -f docker-compose.prod.nontls.yml -f docker-compose.prod.tls.yml stop

build:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml build

update-submodules:
	git submodule update --remote --merge

new-version:
	scripts/new_version.py
