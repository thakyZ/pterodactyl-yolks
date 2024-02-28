# ---------------------------------------------
# Steam Proton image
# ---------------------------------------------
FROM        debian:bullseye-slim

LABEL       author="Torsten Widmann" maintainer="info@goover.de" \
            org.opencontainers.image.source="https://github.com/thakyZ/pterodactyl_yolks" \
            org.opencontainers.image.authors="Neko Boi Nick <950594+thakyZ@users.noreply.github.com>, Natalie (https://github.com/CuteNatalie)" \
            org.opencontainers.image.licenses=MIT

## install required packages
RUN         dpkg --add-architecture i386
RUN         apt update
RUN         apt install -y --no-install-recommends wget unzip iproute2 gnupg2 software-properties-common libntlm0 winbind xvfb xauth libncurses5-dev:i386 libncurses6 dbus libgdiplus lib32gcc-s1 moreutils net-tools procps
RUN         apt install -y alsa-tools libpulse0 pulseaudio libpulse-dev libasound2 libao-common gnutls-bin gnupg locales numactl cabextract curl python3 python3-pip python3-yaml python3-setuptools tini file
RUN         useradd -d /home/container -m container

# Insert Steam prompt answers
SHELL 		["/bin/bash", "-o", "pipefail", "-c"]
RUN 		echo steam steam/question select "I AGREE" | debconf-set-selections \
            && echo steam steam/license note '' | debconf-set-selections

## Download Steamcmd directly into the OS
RUN 		apt-get update && apt-get install -y software-properties-common
RUN    		apt-add-repository non-free
RUN    		apt-get update
RUN   		apt-get install -y steamcmd

# Create symlink for executable
RUN 		ln -s /usr/games/steamcmd /usr/bin/steamcmd

# Download Proton GE
RUN         curl -sLOJ "$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | grep browser_download_url | cut -d\" -f4 | egrep .tar.gz)"
RUN         tar -xzf GE-Proton*.tar.gz -C /usr/local/bin/ --strip-components=1
RUN         rm GE-Proton*.*
RUN			mkdir -p /home/container/.steam/steam/steamapps/compatdata/2394010/
RUN			cp -a /usr/local/bin/files/share/default_pfx /home/container/.steam/steam/steamapps/compatdata/2394010/

# Proton Fix machine-id
RUN         rm -f /etc/machine-id
RUN         dbus-uuidgen --ensure=/etc/machine-id
RUN         rm /var/lib/dbus/machine-id
RUN         dbus-uuidgen --ensure

#Setup Protontricks
RUN         python3 -m pip install protontricks

# Set up Winetricks
RUN	        wget -q -O /usr/sbin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
            && chmod +x /usr/sbin/winetricks

## install rcon
RUN         cd /tmp/ \
            && curl -sSL https://github.com/gorcon/rcon-cli/releases/download/v0.10.3/rcon-0.10.3-amd64_linux.tar.gz > rcon.tar.gz \
            && tar xvf rcon.tar.gz \
            && mv rcon-0.10.3-amd64_linux/rcon /usr/local/bin/

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

STOPSIGNAL  SIGINT

COPY        --chown=container:container ./../entrypoint.sh /entrypoint.sh
RUN         chmod +x /entrypoint.sh
ENTRYPOINT  ["/usr/bin/tini", "-g", "--"]
CMD         ["/entrypoint.sh"]
