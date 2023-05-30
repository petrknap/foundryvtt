imageName := foundryvtt
imageTag := latest
networkPort := 30000
dataDir := $(CURDIR)/data
mountedDataDir := /mnt/data
buildHelp := $(shell head -n 1 $(CURDIR)/Dockerfile)

.PHONY: docker-image certificate server server-daemon server-murder

docker-image:
	docker build $(CURDIR) -t $(imageName):$(imageTag) || echo "$(buildHelp)"

certificate:
	docker run --rm -v $(dataDir):$(mountedDataDir) $(imageName):$(imageTag) \
		openssl req \
			-x509 \
			-nodes \
			-days 36500 \
			-newkey rsa \
			-keyout $(mountedDataDir)/Config/self-signed.key \
			-out $(mountedDataDir)/Config/self-signed.crt \
			-subj /O=FoundryVTT/

server:
	docker run --rm \
		-h $(imageName) \
		-p $(networkPort):$(networkPort) \
		-v $(dataDir):$(mountedDataDir) \
		$(DOCKER_EXTRA_ARGS) \
		$(imageName):$(imageTag)

server-daemon:
	$(MAKE) server DOCKER_EXTRA_ARGS="-d $(DOCKER_EXTRA_ARGS)"

server-murder:
	docker stop $$(docker ps -q --filter ancestor=$(imageName):$(imageTag))
