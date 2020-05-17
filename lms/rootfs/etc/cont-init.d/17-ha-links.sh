#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: lms
# ==============================================================================

CONFIG="/data/options.json"

function mklink {
  LNK="$2"
  DST="$1"
  BASE=$(dirname "${LNK}")
  
  mkdir -p "${BASE}"
  ln -sv "${DST}" "${LNK}"
}

if [ -r "${CONFIG}" ];then
  LINKS=$(jq --raw-output '.links | length |@sh' ${CONFIG})

  for (( i=0; i < "${LINKS}"; i++ )); do
    LNK=$(jq --raw-output ".links[$i].link" ${CONFIG})
    DST=$(jq --raw-output ".links[$i].dest" ${CONFIG})

    mklink "${DST}" "${LNK}"
  done
fi

