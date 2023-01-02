#!/usr/bin/with-contenv bashio

function path {
  local path
  path=${1}
  if [ ! -d ${path} ]; then
	mkdir -p ${path}
        chown ${LMS_USER} ${path}
  fi
  # option?
  if [ ! -r "${LMS_HACFGDIR}/no_fix_owner" ];then
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
rm -f  "${LMS_HACFGDIR}/fixed_owner"

: > ${LMS_LOGDIR}/${LMS_LOGFIlE:-"server.log"}
chown ${LMS_USER} ${LMS_LOGDIR}/${LMS_LOGFIlE:-"server.log"}
: > ${LMS_LOGDIR}/"perfmon.log"
chown ${LMS_USER} ${LMS_LOGDIR}/"perfmon.log"


if [ -r "${LMS_HACFGDIR}/restore_perms_fix" ];then
	if [ -r "${LMS_PREFS}/server.prefs" ];then
	   if [ ! -r "/data/lms/notbackedup/do_no_restore_perms" ];then
	      # we have run howerver we have been restored form backup so own the files
              chown -Rh "${LMS_USER}" "${LMS_HACFGDIR}"
              path "/data/lms/notbackedup/"
              touch "/data/lms/notbackedup/do_no_restore_perms"
	   fi
	fi
else
    touch "${LMS_HACFGDIR}/restore_perms_fix"
    path "/data/lms/notbackedup/"
    touch "/data/lms/notbackedup/do_no_restore_perms"
fi

if [ "${LMS_set_permissions:-""}" = "true" ];then
    chown -Rh "${LMS_USER}" "${LMS_HACFGDIR}"
fi
