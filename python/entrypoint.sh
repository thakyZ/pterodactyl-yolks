#!/bin/bash
# Borrowed partially from:
# https://github.com/matthewpi/images/blob/master/python/entrypoint.sh


cd /home/container || exit 1

# Make internal Docker IP address available to processes.
INTERNAL_IP=$(ip route get 1 | awk '{print $NF;exit}')
export INTERNAL_IP

# Print current Python version
python --version

# Replace Startup Variables
MODIFIED_STARTUP=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g' | eval echo "$(cat -)")
echo -e ":/home/container$ ${MODIFIED_STARTUP}"

echo "${MODIFIED_STARTUP}" > /home/container/startup.sh
chmod +x /home/container/startup.sh

# Run the Server
# shellcheck disable=SC2086
exec env /home/container/startup.sh
