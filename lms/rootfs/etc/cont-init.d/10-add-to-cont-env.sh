#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: lms
# Set up env from ha
# ==============================================================================

function lms_to_env {
  KEY=$1
  PRE=${2:-""}
  VAL="$3"
  bashio::log.info "Add to cont ENV ${KEY} to ${PRE}${KEY}""=""${VAL}"
  if [[ "${VAL}" != "null" ]];then
    echo -n ${VAL} >/run/s6/container_environment/${PRE}${KEY}
  fi
}

PF="LMS_"

ha_to_env TEST ${PF} "${LMS_ACFG}"
exit
