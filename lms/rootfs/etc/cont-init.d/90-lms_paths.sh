#!/usr/bin/with-contenv bashio

function path {
  local path
  path=${1}
  if [ ! -d ${path} ]; then
	mkdir -p ${path}
        chown ${LMS_USER} ${path}
  fi
  if [ ! -r "${LMS_HACFGDIR}/fixed_owner" ];then
      chown ${LMS_USER} ${path}
  fi
}

path "${LMS_HACFGDIR}"
path "${LMS_PREFS}"
path "${LMS_PREFS}/plugin"
path "${LMS_CACHE}"
path "${LMS_CACHE}/tmp"
path "${LMS_PLUGS}"
path "${LMS_LOGDIR}"
touch "${LMS_HACFGDIR}/fixed_owner"

: > ${LMS_LOGDIR}/${LMS_LOGFIlE:-"server.log"}
chown ${LMS_USER} ${LMS_LOGDIR}/${LMS_LOGFIlE:-"server.log"}
: > ${LMS_LOGDIR}/"perfmon.log"
chown ${LMS_USER} ${LMS_LOGDIR}/"perfmon.log"
