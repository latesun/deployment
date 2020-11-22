FROM golang:1.15.5-alpine

WORKDIR $GOPATH/src/github.com/latesun/gin-demo
COPY . $GOPATH/src/github.com/latesun/gin-demo
RUN GOPROXY="https://goproxy.io" go build -o app main.go

EXPOSE 8080
ENTRYPOINT ["./app"]
