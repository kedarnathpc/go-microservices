FRONT_END_BINARY=frontApp
BROKER_BINARY=brokerApp
AUTH_BINARY=authApp
LOGGER_BINARY=loggerServiceApp

## up: starts all containers in the background without forcing build
up:
	@echo "Starting Docker images..."
	docker-compose up -d
	@echo "Docker images started!"

## up_build: stops docker-compose (if running), builds all projects and starts docker compose
up_build: build_broker build_auth build_logger
	@echo "Stopping docker images (if running...)"
	docker-compose down
	@echo "Building (when required) and starting docker images..."
	docker-compose up --build -d
	@echo "Docker images built and started!"

## down: stop docker compose
down:
	@echo "Stopping docker compose..."
	docker-compose down
	@echo "Done!"

## build_broker: builds the broker binary as a linux executable
build_broker:
	@echo "Building broker binary..."
	cd ./broker-service && env GOOS=linux CGO_ENABLED=0 go build -o ${BROKER_BINARY} ./cmd/api
	@echo "Done!"

## build_logger: builds the logger binary as a linux executable
build_logger:
	@echo "Building logger binary..."
	cd ./logger-service && env GOOS=linux CGO_ENABLED=0 go build -o ${LOGGER_BINARY} ./cmd/api
	@echo "Done!"

## build_auth: builds the auth binary as a linux executable
build_auth:
	@echo "Building auth binary..."
	cd ./authentication-service && env GOOS=linux CGO_ENABLED=0 go build -o ${AUTH_BINARY} ./cmd/api
	@echo "Done!"

## build_front: builds the frone end binary
build_front:
	@echo "Building front end binary..."
	cd ./frontend && env CGO_ENABLED=0 go build -o ${FRONT_END_BINARY} ./cmd/web
	@echo "Done!"

## start: starts the front end
start_front: build_front
	@echo "Starting front end"
	cd ./frontend && ./${FRONT_END_BINARY} &

## stop: stop the front end
stop_front:
	@echo "Stopping front end..."
	@-pkill -SIGTERM -f "./${FRONT_END_BINARY}"
	@echo "Stopped front end!"

## kill docker-proxy running processes
kill_docker_proxy:
	@./kill_docker_proxy.sh

## rebuild local data
rebuild_local_postgres:
	@echo "Deleting local postgres directory from db-data"
	sudo rm -rf ./db-data/postgres
	@echo "making new directory"
	mkdir -p ./db-data/postgres
	@echo "changing permissions of the new made directory"
	chmod 777 ./db-data/postgres

## rebuild local mongo data
rebuild_local_mongo:
	@echo "Deleting local mongo directory from db-data"
	sudo rm -rf ./db-data/mongo
	@echo "making new directory"
	mkdir -p ./db-data/mongo
	@echo "changing permissions of the new made directory"
	chmod 777 ./db-data/mongo