FROM        --platform=$TARGETOS/$TARGETARCH debian:bookworm-slim

LABEL       author="Neko Boi Nick" maintainer="950594+thakyZ@users.noreply.github.com" \
            org.opencontainers.image.source="https://github.com/thakyZ/pterodactyl_yolks" \
            org.opencontainers.image.authors="Neko Boi Nick <950594+thakyZ@users.noreply.github.com>" \
            org.opencontainers.image.licenses=MIT

## Install required packages.
RUN         apt update -y
RUN         apt install -y --no-install-recommends ca-certificates curl git unzip zip tar jq wget ca-certificates \
                                                   python3 python3-dev python3-yaml python3-requests python3-urllib3 \
                                                   ffmpeg iproute2 git sqlite3 libsqlite3-dev dnsutils tzdata \
                                                   build-essential libtool iputils-ping libnss3 tini procps
RUN         useradd -m -d /home/container container

## Install packages used for debugging.
RUN         apt install -y --no-install-recommends net-tools lsof nmap

## Install rcon for debugging.
WORKDIR     /tmp/
RUN         curl -sSL https://github.com/gorcon/rcon-cli/releases/download/v0.10.3/rcon-0.10.3-amd64_linux.tar.gz > rcon.tar.gz
RUN         tar xvf rcon.tar.gz
RUN         mv rcon-0.10.3-amd64_linux/rcon /usr/local/bin/

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

STOPSIGNAL  SIGINT

COPY        --chown=container:container ./../entrypoint.sh /entrypoint.sh
RUN         chmod +x /entrypoint.sh
ENTRYPOINT  ["/usr/bin/tini", "-g", "--"]
CMD         ["/entrypoint.sh"]
