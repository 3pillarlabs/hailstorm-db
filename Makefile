PACKAGE_VERSION = $(shell cat VERSION)
DOCKER_REPO := hailstorm-db

.PHONY: package

package:
	docker build \
	--rm \
	--label org.opencontainers.image.created=$(shell date -u "+%Y-%m-%dT%H:%M:%S%z") 		\
	--label org.opencontainers.image.revision=$${TRAVIS_COMMIT} 					 		\
	--label org.opencontainers.image.licenses=MIT											\
	--label org.opencontainers.image.title="Hailstorm Database"								\
	--label org.opencontainers.image.description="MySQL database with Hailstorm db users" 	\
	-t $${DOCKER_ID}/${DOCKER_REPO}:${PACKAGE_VERSION} .

publish:
	set -ev
	docker tag $${DOCKER_ID}/${DOCKER_REPO}:${PACKAGE_VERSION} $${DOCKER_ID}/${DOCKER_REPO}:latest
	@docker login --username $${DOCKER_ID} -p $${DOCKER_PASSWORD}
	docker push $${DOCKER_ID}/${DOCKER_REPO}:${PACKAGE_VERSION}
	docker push $${DOCKER_ID}/${DOCKER_REPO}:latest

run_local:
	docker run \
	--rm \
	-p 3306:3306 \
	-e MYSQL_RANDOM_ROOT_PASSWORD=true \
	--name hailstorm-db \
	-d \
	hailstorm3/${DOCKER_REPO}:${PACKAGE_VERSION}

run:
	docker run \
	--rm \
	-p 3306:3306 \
	-e MYSQL_RANDOM_ROOT_PASSWORD=true \
	--network ${NETWORK} \
	--name hailstorm-db \
	-d \
	hailstorm3/${DOCKER_REPO}:${PACKAGE_VERSION}

stop:
	docker stop hailstorm-db

mysql_client:
	docker run \
	-it \
	--rm \
	--name hailstorm-db-client \
	--network ${NETWORK} \
	hailstorm3/${DOCKER_REPO}:${PACKAGE_VERSION} \
	mysql -h hailstorm-db -u ${DB_USER} -p
