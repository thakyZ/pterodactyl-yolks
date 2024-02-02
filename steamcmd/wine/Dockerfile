# ---------------------------------------------
# Steam Proton image
# ---------------------------------------------
FROM        debian:bookworm-slim

LABEL       author="Neko Boi Nick" maintainer="950594+thakyZ@users.noreply.github.com"
LABEL       org.opencontainers.image.licenses=MIT

## install required packages
RUN         dpkg --add-architecture i386
RUN         apt update
RUN         apt install -y --no-install-recommends wget iproute2 gnupg2 software-properties-common libntlm0 winbind xvfb xauth libncurses5:i386 libncurses5-dev:i386 libsdl2-2.0-0 libsdl2-2.0-0:i386 libncurses6 libncurses6:i386 dbus libgdiplus lib32gcc-s1
RUN         apt install -y alsa-tools libpulse0 pulseaudio libpulse-dev libasound2 libao-common gnutls-bin gnupg locales numactl cabextract curl python3 python3-pip python3-setuptools tini file tzdata python3 
RUN         useradd -d /home/container -m container

# Download Proton GE
RUN             mkdir -pm755 /etc/apt/keyrings
RUN             wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
RUN             wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources
RUN             apt update
RUN             apt install --install-recommends winehq-staging cabextract wine-binfmt -y

# Proton Fix machine-id
RUN         rm -f /etc/machine-id
RUN         dbus-uuidgen --ensure=/etc/machine-id
RUN         rm /var/lib/dbus/machine-id
RUN         dbus-uuidgen --ensure

# Set up Winetricks
RUN	            wget -q -O /usr/sbin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
                && chmod +x /usr/sbin/winetricks

ENV             HOME=/home/container
ENV             WINEPREFIX=/home/container/.wine
ENV             WINEDLLOVERRIDES="mscoree,mshtml="
ENV             DISPLAY=:0
ENV             DISPLAY_WIDTH=1024
ENV             DISPLAY_HEIGHT=768
ENV             DISPLAY_DEPTH=16
ENV             AUTO_UPDATE=1
ENV             XVFB=1

## install rcon
RUN         cd /tmp/ \
            && curl -sSL https://github.com/gorcon/rcon-cli/releases/download/v0.10.3/rcon-0.10.3-amd64_linux.tar.gz > rcon.tar.gz \
            && tar xvf rcon.tar.gz \
            && mv rcon-0.10.3-amd64_linux/rcon /usr/local/bin/
            
USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

STOPSIGNAL SIGINT

COPY        --chown=container:container ./../entrypoint.sh /entrypoint.sh
RUN         chmod +x /entrypoint.sh
ENTRYPOINT  ["/usr/bin/tini", "-g", "--"]
CMD         [ "/bin/bash", "/entrypoint.sh" ]
