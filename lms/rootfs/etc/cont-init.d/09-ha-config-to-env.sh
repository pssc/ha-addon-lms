#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: lms
# Set up env from ha
# ==============================================================================

function ha_to_env {
  KEY=$1
  PRE=${2:-""}
  VAL=$(bashio::config "${KEY,,}")
  bashio::log.info "Option ${KEY} to ${PRE}${KEY}""=""${VAL}"
  if [[ "${VAL}" != "null" ]];then
    echo -n ${VAL} >/run/s6/container_environment/${PRE}${KEY}
  fi
}

PF="LMS_"

ha_to_env MOUNT
ha_to_env TMPFS
ha_to_env OPTIONS ${PF}
ha_to_env LOGFILE ${PF}
ha_to_env LOGDIR ${PF}
ha_to_env NX ${PF}
ha_to_env set_permissions ${PF}
ha_to_env autoupdate_notify ${PF}
exit
