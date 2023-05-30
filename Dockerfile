# Please, download ZIP file from https://foundryvtt.com/releases/download?build=299&platform=linux first.
ARG FOUNDRYVTT_SRC_FILE="FoundryVTT-11.299.zip"

# See FOUNDRYVTT_SRC_FILE:/resources/app/package.json:release.node_version for correct node version.
FROM node:16

WORKDIR "/FoundryVTT"
VOLUME "/mnt/data"
EXPOSE 30000

ARG FOUNDRYVTT_SRC_FILE
ARG FOUNDRYVTT_TMP_DIR="/tmp/FoundryVTT"
ARG FOUNDRYVTT_TMP_FILE="${FOUNDRYVTT_TMP_DIR}.zip"
ADD ${FOUNDRYVTT_SRC_FILE} ${FOUNDRYVTT_TMP_FILE}
RUN unzip ${FOUNDRYVTT_TMP_FILE} -d ${FOUNDRYVTT_TMP_DIR} \
 && cp -r ${FOUNDRYVTT_TMP_DIR}/resources/app/. ./ \
 && rm -rf ${FOUNDRYVTT_TMP_FILE} ${FOUNDRYVTT_TMP_DIR} \
;

HEALTHCHECK --interval=60s --timeout=3s --retries=3 CMD curl --fail http://localhost:30000/

CMD ["node", "./main.js", "--dataPath=/mnt/data"]

LABEL org.opencontainers.image.title="FoundryVTT" \
      org.opencontainers.image.description="Dockerized Foundry Virtual Tabletop" \
      org.opencontainers.image.authors="petrknap.github.io" \
      org.opencontainers.image.url="https://github.com/petrknap/foundryvtt/" \
