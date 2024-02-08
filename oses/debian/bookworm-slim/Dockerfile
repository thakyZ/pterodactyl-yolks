FROM        --platform=$TARGETOS/$TARGETARCH debian:bookworm-slim

LABEL       author="Neko Boi Nick" maintainer="950594+thakyZ@users.noreply.github.com"

RUN         apt update -y \
            && apt install -y --no-install-recommends ca-certificates curl git unzip zip tar jq wget ca-certificates \
                                                      python3 python3-dev python3-yaml python3-requests python3-urllib3 \
                                                      ffmpeg iproute2 git sqlite3 libsqlite3-dev dnsutils tzdata build-essential \
                                                      libtool iputils-ping libnss3 tini net-tools lsof \
            && useradd -m -d /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

STOPSIGNAL  SIGINT

COPY        --chown=container:container ./../entrypoint.sh /entrypoint.sh
RUN         chmod +x /entrypoint.sh
ENTRYPOINT  ["/usr/bin/tini", "-g", "--"]
CMD         ["/entrypoint.sh"]
