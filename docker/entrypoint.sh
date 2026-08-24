#!/bin/sh
set -eu

WORKSPACE_DIR="${WORKSPACE_DIR:-/workspace}"
OPENSIM_DIR="${OPENSIM_DIR:-/opt/opensim}"
CONFIG_DIR="${CONFIG_DIR:-/config}"
BIN_DIR="${BIN_DIR:-${OPENSIM_DIR}/bin}"
OPENSIM_SERVER_DLL="${OPENSIM_SERVER_DLL:-OpenSim.dll}"

mkdir -p "${WORKSPACE_DIR}"

# Ensure OpenSim configuration files are symlinked to the config directory, so that OpenSim will use them.
if [ -f "${CONFIG_DIR}/Robust.ini" -a ! -L "${BIN_DIR}/Robust.ini" ] ; then
    printf '[opensim] Symlinking Robust.ini.\n'
    rm -f "${BIN_DIR}/Robust.ini"
    ln -sf "${CONFIG_DIR}/Robust.ini" "${BIN_DIR}/Robust.ini"
fi

if [ -f "${CONFIG_DIR}/OpenSim.ini" -a  ! -L "${BIN_DIR}/OpenSim.ini" ]; then
    printf '[opensim] Symlinking OpenSim.ini.\n'
    rm -f "${BIN_DIR}/OpenSim.ini"
    ln -sf "${CONFIG_DIR}/OpenSim.ini" "${BIN_DIR}/OpenSim.ini"
fi

if [ -f "${CONFIG_DIR}/startup_commands.txt" -a ! -L "${BIN_DIR}/startup_commands.txt" ]; then
    printf '[opensim] Symlinking startup_commands.txt.\n'
    rm -f "${BIN_DIR}/startup_commands.txt"
    ln -sf "${CONFIG_DIR}/startup_commands.txt" "${BIN_DIR}/startup_commands.txt"
fi

if [ -d "${CONFIG_DIR}/Regions" -a ! -L "${BIN_DIR}/Regions" ]; then
    printf '[opensim] Symlinking Regions.\n'
    rm -fr "${BIN_DIR}/Regions"
    ln -sf "${CONFIG_DIR}/Regions" "${BIN_DIR}/Regions"
fi

if [ -d "${CONFIG_DIR}/config-include" -a ! -L "${BIN_DIR}/config-include" ]; then
    rm -fr "${BIN_DIR}/config-include"
    printf '[opensim] Symlinking config-include.\n'
    ln -sf "${CONFIG_DIR}/config-include" "${BIN_DIR}/config-include"
fi

if [ -f "${CONFIG_DIR}/config-include/FlotsamCache.ini" -a ! -f "${BIN_DIR}/config-include/FlotsamCache.ini" -a -f "${BIN_DIR}/config-include/FlotsamCache.ini.example" ]; then
    cp "${BIN_DIR}/config-include/FlotsamCache.ini.example" "${BIN_DIR}/config-include/FlotsamCache.ini"
    printf '[opensim] Created FlotsamCache.ini from example.\n'
fi

touch "${BIN_DIR}/startup_commands.txt"
touch "${BIN_DIR}/shutdown_commands.txt"

cd "${BIN_DIR}"
ulimit -s 1048576

echo "[opensim] Starting OpenSimulator [${OPENSIM_SERVER_DLL:-OpenSim.dll}] in foreground mode..."
exec dotnet ${OPENSIM_SERVER_DLL:-OpenSim.dll} -console rest
