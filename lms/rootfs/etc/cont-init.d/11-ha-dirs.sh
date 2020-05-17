#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: lms
# ==============================================================================

CONFIG="/data/options.json"
OPTION=".dirs"
COMMAND="mklmsdir"

function mklmsdir {
  V=$1
  mkdir -p "${V}"
  chown ${LMS_USER} "${V}"
  chmod g+rws "${V}"
  echo mklmsdir "${V}"
}

if [ -r "${CONFIG}" ];then
  S=$(jq --raw-output "${OPTION} | length |@sh" ${CONFIG})

  for (( i=0; i < "${S}"; i++ )); do
    V=$(jq --raw-output "${OPTION}[$i]" ${CONFIG})

    ${COMMAND} ${V}
  done
fi

