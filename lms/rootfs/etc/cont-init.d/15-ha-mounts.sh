#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: lms
# ==============================================================================

CONFIG="/data/options.json"
OPTION=".mounts"

#FIXME
mkdir -p /data/mnt

if [ -r "${CONFIG}" ];then
  S=$(jq --raw-output "${OPTION} | length |@sh" ${CONFIG})

  for (( i=0; i < "${S}"; i++ )); do
    MOUNT=$(jq --raw-output "${OPTION}[$i]" ${CONFIG})

    mount -v ${MOUNT}
  done
fi

