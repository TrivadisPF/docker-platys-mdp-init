ARG VERSION=latest

FROM alpine/curl:${VERSION}

USER root

# Set environment variables
ENV NIFI_TOOLKIT_VERSION=2.0.0
ENV NIFI_TOOLKIT_HOME=/opt/nifi-toolkit

# install envsubst, jq, wait4x, bash shell, minio-mc
RUN apk add --no-cache gettext libintl jq wait4x bash openjdk21 && \
    arch=$(uname -m) && \
    if [ "$arch" = "aarch64" ]; then \
        mc_url="https://dl.min.io/client/mc/release/linux-arm64/mc"; \
    else \
        mc_url="https://dl.min.io/client/mc/release/linux-amd64/mc"; \
    fi && \
    curl -sSL "$mc_url" --create-dirs -o /usr/local/bin/mc && \
    chmod +x /usr/local/bin/mc && \
    wget https://archive.apache.org/dist/nifi/${NIFI_TOOLKIT_VERSION}/nifi-toolkit-${NIFI_TOOLKIT_VERSION}-bin.zip -O /tmp/nifi-toolkit.zip && \
    unzip /tmp/nifi-toolkit.zip -d /opt && \
    mv /opt/nifi-toolkit-${NIFI_TOOLKIT_VERSION} ${NIFI_TOOLKIT_HOME} && \
    rm /tmp/nifi-toolkit.zip

ENV PATH=$PATH:/root/minio-binaries:${NIFI_TOOLKIT_HOME}/bin

# Create an alias for nifi-toolkit to cli.sh
RUN echo "alias nifi-toolkit='cli.sh'" >> /etc/profile

# Set bash as the default shell
SHELL ["/bin/bash", "-c"]

WORKDIR /app
COPY . /app

ENTRYPOINT ["./docker-entrypoint.sh"]