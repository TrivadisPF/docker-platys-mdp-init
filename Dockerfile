ARG VERSION=latest

FROM alpine/curl:${VERSION}

USER root

# install envsubst, jq, wait4x, bash shell, minio-mc
RUN apk add --no-cache gettext libintl jq wait4x bash && \
    arch=$(uname -m) && \
    if [ "$arch" = "aarch64" ]; then \
        mc_url="https://dl.min.io/client/mc/release/linux-arm64/mc"; \
    else \
        mc_url="https://dl.min.io/client/mc/release/linux-amd64/mc"; \
    fi && \
    curl -sSL "$mc_url" --create-dirs -o /usr/local/bin/mc && \
    chmod +x /usr/local/bin/mc

ENV PATH=$PATH:/root/minio-binaries

# Set bash as the default shell
SHELL ["/bin/bash", "-c"]

WORKDIR /app
COPY . /app

ENTRYPOINT ["./docker-entrypoint.sh"]