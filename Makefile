imageName := foundryvtt
imageTag := latest
networkPort := 30000
buildHelp := $(shell head -n 1 $(CURDIR)/Dockerfile)

.PHONY: docker-image server server-daemon server-murder

docker-image:
	docker build $(CURDIR) -t $(imageName):$(imageTag) || echo "$(buildHelp)"

server:
	docker run --rm \
		-h $(imageName) \
		-p $(networkPort):$(networkPort) \
		-v $(CURDIR)/data:/mnt/data \
		$(DOCKER_EXTRA_ARGS) \
		$(imageName):$(imageTag)

server-daemon:
	$(MAKE) server DOCKER_EXTRA_ARGS="-d $(DOCKER_EXTRA_ARGS)"

server-murder:
	docker stop $$(docker ps -q --filter ancestor=$(imageName):$(imageTag))
