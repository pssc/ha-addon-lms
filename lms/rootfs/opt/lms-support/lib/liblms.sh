#!/usr/bin/env bash
# ==============================================================================
# Home Assistant Community Add-ons: liblms
#
# ==============================================================================
set -o errexit  # Exit script when a command exits with non-zero status
set -o errtrace # Exit on error inside any functions or sub-shells
set -o nounset  # Exit script on use of an undefined variable
set -o pipefail # Return exit status of the last command in the pipe that failed

# ==============================================================================
# GLOBALS
# ==============================================================================

# version number
readonly LIBLMS_VERSION="0.0.1"

# Stores the location of this library
readonly __LIBLMS_LIB_DIR=$(dirname "${BASH_SOURCE[0]}")

function dump_mariadb() {
    local DDDIR=${1:-$BDBDIR}
    local FILEDL=${2:-"mariadb-dump.$(date -Iseconds).xz"}
    local FILEDT="${DDDIR}/.$FILEDL"
    local FILED="${DDDIR}/$FILEDL"
    echo "$(date -Iseconds) [INFO] Dumping mariadb system ${FILED}"
    mysqldump -A --quick | xz ${XZDUMPOPTS:-"-T0"} >"${FILEDT}"
    EC=$?
    #FIXME set-e will not work if?
    echo "$(date -Iseconds) [Info] mysqldump ${FILED} / xz exit ($EC) size: $(du ${FILEDT} | cut -f 1)"
    du ${FILEDT}
    if [ ! -z "${FILEDT}" ];then
            mv "${FILEDT}" "${FILED}"
	    sync
	    return 0
    fi
    return 1
}

function restore_mariadb() {
    # FIXME 
    local LATEST_DUMP=${1:-$(find "/data/dump" "${BDBDIR}" -name 'mariadb-dump.*' | sort -t . -k 2| tail -1)}
    echo "$(date -Iseconds) [INFO] Restoring mariadb system with ${LATEST_DUMP}"
    if [ -r "${LATEST_DUMP}" ];then
       # check? integrity of dump
       xzcat "${LATEST_DUMP}" | mysql
       # FIXME
    fi
    echo "$(date -Iseconds) [INFO] Restored"
}

function wait_mariadb() {
    local WC=0
    # Wait until DB is running
    while ! mysql -e "" 2> /dev/null; do
       sleep 1
       WC=$(($WC+1))
       if [ "$WC" -gt "$WAITS" ];then exit 2;fi
    done
    echo "[INFO] Waited $WC counts for mariadb"
}
