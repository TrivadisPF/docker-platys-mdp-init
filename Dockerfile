ARG VERSION=latest

FROM alpine/curl:${VERSION}

USER root

RUN apk add gettext libintl jq wait4x bash

# Set bash as the default shell
SHELL ["/bin/bash", "-c"]

WORKDIR /app
COPY . /app

ENTRYPOINT ["./docker-entrypoint.sh"]