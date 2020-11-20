.PHONY: traefik
traefik: traefik/docker-compose.yml
	mkdir -p $(HOME)/data/traefik
	docker network create gateway
	docker-compose -f traefik/docker-compose.yml up -d

.PHONY: stop-traefik
stop-traefik: traefik/docker-compose.yml
	docker-compose -f traefik/docker-compose.yml down
	docker network rm gateway

.PHONY: simple-web
simple-web: sample-service/web/gin-demo.yml
	cd sample-service/web && docker build --no-cache -t gin-demo:0.0.1 .
	docker-compose -f sample-service/web/gin-demo.yml up -d

.PHONY: stop-simple-web
stop-simple-web: sample-service/web/gin-demo.yml
	docker-compose -f sample-service/web/gin-demo.yml down

.PHONY: simple-web-3
simple-web-3:
	cd simple-web && docker build --no-cache -t gin-demo:0.0.1 .
	docker-compose -f simple-web/gin-demo.yml up -d --scale gin-demo=3

.PHONY: redis
redis:
	mkdir -p $(HOME)/data/redis
	docker-compose -f db/redis/redis.yml up -d

.PHONY: mysql
mysql:
	docker network create db
	mkdir -p $(HOME)/data/mysql
	docker-compose -f db/mysql/docker-compose.yml up -d

.PHONY: stop-mysql
stop-mysql:
	docker-compose -f db/mysql/docker-compose.yml down
	docker network rm db

.PHONY: monitor
monitor:
	docker network create monitor
	docker-compose -f monitor/docker-compose.yml up -d

.PHONY: stop-monitor
stop-monitor:
	docker-compose -f monitor/docker-compose.yml down
	docker network rm monitor
