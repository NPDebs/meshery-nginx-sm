protoc-setup:
	cd meshes
	wget https://raw.githubusercontent.com/layer5io/meshery/master/meshes/meshops.proto

proto:	
	protoc -I meshes/ meshes/meshops.proto --go_out=plugins=grpc:./meshes/

docker:
	docker build -t layer5/meshery-nginx-sm .

docker-run:
	(docker rm -f meshery-nginx-sm) || true
	docker run --name meshery-nginx-sm -d \
	-p 10010:10010 \
	-e DEBUG=true \
	layer5/meshery-nginx-sm


## Build and run Adapter locally
run:
	go$(v) mod tidy -compat=1.17; \
	DEBUG=true GOPROXY=direct GOSUMDB=off go run main.go

run-force-dynamic-reg:
	FORCE_DYNAMIC_REG=true DEBUG=true GOPROXY=direct GOSUMDB=off go run main.go

.PHONY: error
error:
	go run github.com/layer5io/meshkit/cmd/errorutil -d . analyze -i ./helpers -o ./helpers
