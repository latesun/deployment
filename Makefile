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
	docker-compose -f database/redis/redis.yml up -d

.PHONY: mysql
mysql:
	mkdir -p $(HOME)/data/mysql
	docker-compose -f database/mysql/mysql.yml up -d

.PHONY: es
es:
	mkdir -p $(HOME)/data/{es,kibane}
	docker-compose -f database/es/es.yml up -d
stop-es:
	docker-compose -f database/es/es.yml down

.PHONY: rabbitmq
rabbitmq:
	mkdir -p $(HOME)/data/rabbitmq
	docker-compose -f mq/rabbitmq/rabbitmq.yml up -d

stop-rabbitmq:
	docker-compose -f mq/rabbitmq/rabbitmq.yml down

.PHONY: monitor
monitor:
	docker network create monitor
	docker-compose -f monitor/docker-compose.yml up -d

.PHONY: stop-monitor
stop-monitor:
	docker-compose -f monitor/docker-compose.yml down
	docker network rm monitor
