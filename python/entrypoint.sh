#!/bin/bash
# Borrowed partially from:
# https://github.com/matthewpi/images/blob/master/python/entrypoint.sh

# Default the TZ environment variable to UTC.
TZ=${TZ:-UTC}
export TZ

# Set environment variable that holds the Internal Docker IP
INTERNAL_IP=$(ip route get 1 | awk '{print $NF;exit}')
export INTERNAL_IP

# Switch to the container's working directory
cd /home/container || exit 1

# Print Python version
printf "\033[1m\033[33mcontainer@pterodactyl~ \033[0mpython --version\n"
python --version

# Replace variables in the startup command
PARSED=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g' | eval echo "$(cat -)")
printf "\033[1m\033[33mcontainer@pterodactyl~ \033[0m%s\n" "$PARSED"

# Run the startup command
# shellcheck disable=SC2086
exec env ${PARSED}
