dockerfile := $(CURDIR)/Dockerfile
imageName := foundryvtt
imageTag := $(subst ARG FOUNDRYVTT_VERSION=,,$(shell grep "ARG FOUNDRYVTT_VERSION=" $(dockerfile)))
networkPort := $(subst EXPOSE ,,$(shell grep "EXPOSE " $(dockerfile)))
dataDir := $(CURDIR)/data
mountedDataDir := $(subst VOLUME ,,$(shell grep "VOLUME " $(dockerfile)))
tempDir := $(CURDIR)/temp
mountedTempDir := /tmp
buildHelp := $(subst \# ,,$(shell head -n 1 $(dockerfile)))

.PHONY: docker-image .docker-run server server-daemon server-murder certificate test

docker-image:
	docker build $(CURDIR) \
		-f $(dockerfile) \
		-t $(imageName):$(imageTag) \
		-t $(imageName):latest \
	|| echo "$(buildHelp)"

.docker-run:
	docker run --rm \
		-h $(imageName) \
		-v $(dataDir):$(mountedDataDir) \
		-v $(tempDir):$(mountedTempDir) \
		$(DOCKER_EXTRA_ARGS) \
		$(imageName):$(imageTag) \
		$(DOCKER_CMD)

server:
	$(MAKE) .docker-run DOCKER_EXTRA_ARGS="-p $(networkPort):$(networkPort) $(DOCKER_EXTRA_ARGS)"

server-daemon:
	$(MAKE) server DOCKER_EXTRA_ARGS="-d $(DOCKER_EXTRA_ARGS)"

server-murder:
	docker stop $$(docker ps -q --filter ancestor=$(imageName))

certificate:
	$(MAKE) .docker-run DOCKER_CMD="\
		openssl req -newkey rsa -x509 -nodes \
			-days 36500 \
			-keyout $(mountedDataDir)/Config/self-signed.key \
			-out $(mountedDataDir)/Config/self-signed.crt \
			-subj /O=$(imageName)/ \
	"

test:
	$(MAKE) docker-image
	$(MAKE) certificate
	$(MAKE) server &
	sleep 30
	$(MAKE) server-murder
	$(MAKE) server-daemon
	sleep 30
	$(MAKE) server-murder
