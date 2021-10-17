#!/bin/bash
cd /home/container

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

# Print current Python version
python --version

# Replace Startup Variables
MODIFIED_STARTUP=$(echo "${STARTUP@Q}" | sed -e 's/{{/${/g' -e 's/}}/}/g' | eval echo "$(cat -)")
echo -e ":/home/container$ ${MODIFIED_STARTUP}"

# Run the startup command
# shellcheck disable=SC2086
exec env ${PARSED}
