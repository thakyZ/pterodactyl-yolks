#!/bin/bash
# Borrowed partially from:
# https://github.com/parkervcp/yolks/blob/master/python/entrypoint.sh

cd /home/container || exit 1

# Make internal Docker IP address available to processes.
export INTERNAL_IP=$(ip route get 1 | awk '{print $NF;exit}')

# Print current Python version
printf "\033[1m\033[33mcontainer@pterodactyl~ \033[0mpython --version\n"
python --version

# Replace Startup Variables
MODIFIED_STARTUP=$(echo -e $(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g'))
printf "\033[1m\033[33mcontainer@pterodactyl~ \033[0m%s\n" "$MODIFIED_STARTUP"

# Run the Server
eval ${MODIFIED_STARTUP}
