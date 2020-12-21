.PHONY: \
	traefik stop-traefik \
	simple-web stop-simple-web \
	simple-web-3 stop-simple-web-3 \
	redis stop-redis \
	mysql stop-mysql \
	etcd stop-etcd

traefik: traefik/docker-compose.yml ## 构建 Traefik 服务
	docker-compose -f traefik/docker-compose.yml up -d

stop-traefik: traefik/docker-compose.yml
	docker-compose -f traefik/docker-compose.yml down

gateway := `docker network ls -q -f name=gateway`
gin_demo := `docker image ls -q gin-demo:0.0.1`
web_dir = sample-service/web
gin_yml = $(web_dir)/gin-demo.yml

simple-web: $(gin_yml)
	@if [ -z $(gateway) ] ; then docker network create gateway; fi
	@if [ -z $(gin_demo) ] ; then cd $(web_dir) && docker build --no-cache -t gin-demo:0.0.1 . ; fi
	docker-compose -f $(gin_yml) up -d

stop-simple-web: $(gin_yml)
	docker-compose -f $(gin_yml) down

simple-web-3:
	@if [ -z $(gateway) ] ; then docker network create gateway; fi
	@if [ -z $(gin_demo) ] ; then cd $(web_dir) && docker build --no-cache -t gin-demo:0.0.1 . ; fi
	docker-compose -f $(gin_yml) up -d --scale gin-demo=3

redis:
	mkdir -p $(HOME)/compose/redis/data
	docker-compose -f db/redis/redis.yml up -d

stop-redis:
	docker-compose -f db/redis/redis.yml down

mysql:
	mkdir -p $(HOME)/compose/mysql
	docker-compose -f db/mysql/docker-compose.yml up -d

stop-mysql:
	docker-compose -f db/mysql/docker-compose.yml down

monitor:
	docker network create monitor
	docker-compose -f monitor/docker-compose.yml up -d

stop-monitor:
	docker-compose -f monitor/docker-compose.yml down
	docker network rm monitor

etcd: ## 启动 etcd
	docker network create etcd
	mkdir -p $(HOME)/compose/etcd
	docker-compose -f db/etcd/docker-compose.yml up -d

stop-etcd: ## 关闭 etcd
	docker-compose -f db/etcd/docker-compose.yml down
	docker network rm etcd

es: ## 启动 es
	docker network create elastic
	mkdir -p $(HOME)/compose/etcd
	docker-compose -f db/es/docker-compose.yml up -d

stop-es: ## 关闭 es
	docker-compose -f db/es/docker-compose.yml down
	docker network rm elastic

ci: ## 启动 Gitea
	docker-compose -f gitea/docker-compose.yml up -d

stop-ci: ## 关闭 Gitea
	docker-compose -f gitea/docker-compose.yml down

help: ## 查看帮助文档
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'
