# Please, download file from https://foundryvtt.com/releases/download?build=300&platform=linux first.
ARG FOUNDRYVTT_VERSION=11.300

# See FOUNDRYVTT_FILE:/resources/app/package.json:release.node_version for correct node version.
FROM node:16-alpine

RUN sed -i 's/https:/http:/g' /etc/apk/repositories \
 && apk add --no-cache \
    curl \
    openssl \
    unzip \
 && sed -i 's/http:/https:/g' /etc/apk/repositories \
;

WORKDIR "/FoundryVTT"
VOLUME "/mnt/data"
EXPOSE 30000

ARG FOUNDRYVTT_VERSION
ARG FOUNDRYVTT_FILE="FoundryVTT-${FOUNDRYVTT_VERSION}.zip"
ADD "${FOUNDRYVTT_FILE}" "${FOUNDRYVTT_FILE}"
RUN unzip "${FOUNDRYVTT_FILE}" "resources/app/*" -d ./ \
 && rm "${FOUNDRYVTT_FILE}" \
;

HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD curl --fail --insecure https://localhost:30000/ || curl --fail http://localhost:30000/

CMD ["node", "resources/app/main.js", "--dataPath=/mnt/data"]

LABEL org.opencontainers.image.title="FoundryVTT" \
      org.opencontainers.image.description="Dockerized Foundry Virtual Tabletop" \
      org.opencontainers.image.authors="petrknap.github.io" \
      org.opencontainers.image.url="https://github.com/petrknap/foundryvtt/" \
