.PHONY: traefik
traefik:
	# create date directory
	mkdir -p $(HOME)/data/traefik
	docker-compose -f traefik/traefik.yml up -d

.PHONY: simple-web
simple-web:
	cd simple-web && docker build --no-cache -t gin-demo:0.0.1 .
	docker-compose -f simple-web/gin-demo.yml up -d

simple-web-3:
	cd simple-web && docker build --no-cache -t gin-demo:0.0.1 .
	docker-compose -f simple-web/gin-demo.yml up -d --scale gin-demo=3
