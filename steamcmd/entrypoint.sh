#!/bin/bash

#
# Copyright (c) 2021 Matthew Penner
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

# Wait for the container to fully initialize
sleep 1

# Default the TZ environment variable to UTC.
TZ=${TZ:-UTC}
export TZ

# Set environment variable that holds the Internal Docker IP
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# Set environment for Steam Proton
if [ -f "/usr/local/bin/proton" ]; then
    if [ -n "${SRCDS_APPID}" ]; then
	    mkdir -p "/home/container/.steam/steam/steamapps/compatdata/${SRCDS_APPID}"
        export STEAM_COMPAT_CLIENT_INSTALL_PATH="/home/container/.steam/steam"
        export STEAM_COMPAT_DATA_PATH="/home/container/.steam/steam/steamapps/compatdata/${SRCDS_APPID}"
		# Fix for pipx with protontricks
        export PATH=$PATH:/root/.local/bin
    else
        echo -e "----------------------------------------------------------------------------------"
        echo -e "WARNING!!! Proton needs variable SRCDS_APPID, else it will not work. Please add it"
        echo -e "Server stops now"
        echo -e "----------------------------------------------------------------------------------"
        exit 0
    fi
fi

# Switch to the container's working directory
cd /home/container || exit 1

## just in case someone removed the defaults.
if [ "${STEAM_USER}" == "" ]; then
    echo -e "steam user is not set.\n"
    echo -e "Using anonymous user.\n"
    STEAM_USER=anonymous
    STEAM_PASS=""
    STEAM_AUTH=""
	STEAM_LOGIN="${STEAM_USER}"
else
    echo -e "user set to ${STEAM_USER}"
	STEAM_LOGIN="${STEAM_USER} ${STEAM_PASS} ${STEAM_AUTH}"
fi

## if auto_update is not set or to 1 update
if [ -z "${AUTO_UPDATE}" ] || [ "${AUTO_UPDATE}" == "1" ]; then
    # Update Source Server
    if [ -n "${SRCDS_APPID}" ]; then
        SRCDS_BETAID_OPT=""
        SRCDS_BETAPASS_OPT=""
        HLDS_GAME_OPT=""
        VALIDATE_OPT=""
        if [ -n "${SRCDS_BETAID}" ]; then
            SRCDS_BETAID_OPT="-beta ${SRCDS_BETAID}"
        fi
        if [ -n "${SRCDS_BETAPASS}" ]; then
            SRCDS_BETAPASS_OPT="-betapassword ${SRCDS_BETAPASS}"
        fi
        if [ -n "${HLDS_GAME}" ]; then
            HLDS_GAME_OPT="+app_set_config 90 mod ${HLDS_GAME}"
        fi
        if [ -n "${VALIDATE}" ]; then
            VALIDATE_OPT="validate"
        fi

	    if [ "${STEAM_USER}" == "anonymous" ]; then
			echo "Running SteamCMD:"
			echo "./steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir \"${STEAMCMD_INSTALLDIR:-/home/container}\" +login \"${STEAM_LOGIN}\" +app_update \"${SRCDS_APPID}\" \"${SRCDS_BETAID_OPT}\" \"${SRCDS_BETAPASS_OPT}\" \"${HLDS_GAME_OPT}\" \"${VALIDATE_OPT}\" +quit"
            ./steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir "${STEAMCMD_INSTALLDIR:-/home/container}" +login "${STEAM_LOGIN}" +app_update "${SRCDS_APPID}" "${SRCDS_BETAID_OPT}" "${SRCDS_BETAPASS_OPT}" "${HLDS_GAME_OPT}" "${VALIDATE_OPT}" +quit
	    else
            numactl --physcpubind=+0 steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "${STEAMCMD_INSTALLDIR:-/home/container}" +login "${STEAM_LOGIN}" +app_update "${SRCDS_APPID}" "${SRCDS_BETAID_OPT}" "${SRCDS_BETAPASS_OPT}" "${HLDS_GAME_OPT}" "${VALIDATE_OPT}" +quit
	    fi
    else
        echo -e "No appid set. Starting Server"
    fi

else
    echo -e "Not updating game server as auto update was set to 0. Starting Server"
fi


# Replace Startup Variables
MODIFIED_STARTUP=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo -e ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval "${MODIFIED_STARTUP}"
