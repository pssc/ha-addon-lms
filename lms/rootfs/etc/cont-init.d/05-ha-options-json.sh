#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: lms
# Set up config from saved
# ==============================================================================

CF="/config/lms/addon/options.json"
CD="/data/options.json"
CS="${CD}.orig"

function main {
  KEY="saved"
  VAL=$(bashio::config "${KEY,,}")
  if [[ "${VAL}" = "true" ]];then
    if [[ -f "${CF}" ]];then
      bashio::log.info "Using Saved config"
      mv "${CD}" "${CS}"
      cp "${CF}" "${CD}"
      jq -C "" <"${CD}"
    fi
  fi
}

main

exit
