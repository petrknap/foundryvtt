# Please, download file from https://foundryvtt.com/releases/download?build=326&platform=linux first.
ARG FOUNDRYVTT_VERSION=12.326

# See FOUNDRYVTT_FILE:/resources/app/package.json:release.node_version for correct node version.
FROM node:18

WORKDIR "/FoundryVTT"
VOLUME "/mnt/data"
EXPOSE 30000

ARG FOUNDRYVTT_VERSION
ARG FOUNDRYVTT_FILE="FoundryVTT-${FOUNDRYVTT_VERSION}.zip"
COPY "${FOUNDRYVTT_FILE}" "${FOUNDRYVTT_FILE}"
# hadolint ignore=DL3003
RUN unzip "${FOUNDRYVTT_FILE}" "resources/app/*" -d ./ \
 && rm "${FOUNDRYVTT_FILE}" \
 && cd "resources/app" \
 && rm -rf "node_modules/classic-level" \
 && npm install \
;

HEALTHCHECK --interval=3m --timeout=3s --retries=3 CMD curl --fail --insecure https://localhost:30000/ || curl --fail http://localhost:30000/

CMD ["node", "resources/app/main.js", "--dataPath=/mnt/data"]

LABEL org.opencontainers.image.title="FoundryVTT" \
      org.opencontainers.image.description="Dockerized Foundry Virtual Tabletop" \
      org.opencontainers.image.authors="Petr Knap <8299754+petrknap@users.noreply.github.com>" \
      org.opencontainers.image.url="https://github.com/petrknap/foundryvtt/" \
