PROJECT?=github.com/milangrahovac/twitter-stat
APP?=twitter-stat
PORT?=8000

RELEASE?=0.0.1
COMMIT?=$(shell git rev-parse --short HEAD)
BUILD_TIME?=$(shell date -u '+%Y-%m-%d_%H:%M:%S')
CONTAINER_IMAGE?=docker.io/mgrah/${APP}

 
GOOS?=linux
GOARCH?=amd64

clean:
	rm -f ${APP} ./cmd/...
 
build: clean
	CGO_ENABLED=0 GOOS=${GOOS} GOARCH=${GOARCH} go build \
 		-ldflags "-s -w -X ${PROJECT}/version.Release=${RELEASE} \
 		-X ${PROJECT}/version.Commit=${COMMIT} -X ${PROJECT}/version.BuildTime=${BUILD_TIME}" \
 		-o ${APP} ./cmd/...
 
container: build
	docker build -t $(CONTAINER_IMAGE):$(RELEASE) .

push: container
	docker push $(CONTAINER_IMAGE):$(RELEASE) 

run: container
	docker stop $(CONTAINER_IMAGE):$(RELEASE) || true && docker rm $(CONTAINER_IMAGE):$(RELEASE) || true
	docker run --name ${APP} -p ${PORT}:${PORT} --rm \
		-e "PORT=${PORT}" \
		$(CONTAINER_IMAGE):$(RELEASE)
 
test:
	go test -v -race ./...

