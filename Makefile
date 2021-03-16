run:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up
run-detached:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
stop:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml stop

run-dev-tls:
	docker-compose -f docker-compose.yml -f docker-compose.dev.tls.yml up
run-dev-tls-detached:
	docker-compose -f docker-compose.yml -f docker-compose.dev.tls.yml up -d

run-prod-nontls:
	docker-compose -f docker-compose.yml -f docker-compose.prod.nontls.yml up
run-prod-nontls-detached:
	docker-compose -f docker-compose.yml -f docker-compose.prod.nontls.yml up -d

update-submodules:
	git submodule update --remote --merge
