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

if [ -x "${LMS_OCFG}" ]; then
   if [ "${LMS_migrate_config:-""}" = "true" ];then
        bashio::log.info " Config migration"
	if [ -d "${LMS_OCFG}" -a -L "${LMS_CFG}" ];then
                bashio::log.info " Trying Config migration"
		# Delete Link
		rm -v "${LMS_CFG}"
		# Move dir and error delete copy and abort
		mv -v "${LMS_OCFG}" "${LMS_CFG}"
		if [ $? -gt 0 ];then
                        bashio::log.error " Migration Failed error during mv command tidying up deleting copy in config space."
			rm -rvf "${LMS_CFG}"
			exit 1
		fi
	else
           bashio::log.info " Config migration skiped source not dir or dest not link"
	fi
   else
     # not migrating
     if [ ! -x "${LMS_CFG}" ] ;then
        bashio::log.info " Configiuring to use old config inlinking to ${LMS_OCFG}"
        ln -s ${LMS_OCFG} ${LMS_CFG}
     else
        bashio::log.info " /config/lms exists"
     fi
   fi
else
   bashio::log.info " No HA lms config exists at ${LMS_OCFG}"
fi

path "${LMS_HACFGDIR}"
path "${LMS_PREFS}"
path "${LMS_PREFS}/plugin"
path "${LMS_CACHE}"
path "${LMS_CACHE}/tmp"
path "${LMS_PLUGS}"
path "${LMS_LOGDIR}"
path "${LMS_CFG}/content"
path "${LMS_CFG}/content/playlists"
rm -f  "${LMS_HACFGDIR}/fixed_owner"

: > ${LMS_LOGDIR}/${LMS_LOGFIlE:-"server.log"}
chown ${LMS_USER} ${LMS_LOGDIR}/${LMS_LOGFIlE:-"server.log"}
: > ${LMS_LOGDIR}/"perfmon.log"
chown ${LMS_USER} ${LMS_LOGDIR}/"perfmon.log"

# autofix for perms post restore
if [ -r "${LMS_HACFGDIR}/restore_perms_fix" ];then
	if [ -r "${LMS_PREFS}/server.prefs" ];then
	   if [ ! -r "/data/lms/notbackedup/do_no_restore_perms" ];then
              bashio::log.info "Restore perms and onwership ${LMS_USER} on ${LMS_CFG}"
              LMS_set_permissions=true
              path "/data/lms/notbackedup/"
              touch "/data/lms/notbackedup/do_no_restore_perms"
	   fi
           bashio::log.debug "Do not restore perms"
	fi
else
    touch "${LMS_HACFGDIR}/restore_perms_fix"
    path "/data/lms/notbackedup/"
    touch "/data/lms/notbackedup/do_no_restore_perms"
fi

# Check file see if we need to fix perms automatically is the above needed?
if [[ -O "${LMS_CACHE}/plugin-data.yaml" ]]; then
    if [[ ! -r "/data/lms/no_perm_fix" ]];then
       # owned by root(current euid) so fix,
       LMS_set_permissions=true
       bashio::log.info "Auto fix perm and ownership activated"
    else
       bashio::log.info "Auto fix prem and ownership triggred but disabled"
fi

if [ "${LMS_set_permissions:-""}" = "true" ];then
    bashio::log.info "Set perms amd owner ${LMS_USER} on ${LMS_CFG}"
    id ${LMS_USER}
    V=""
    if bashio::debug; then
      ls -la "${LMS_CFG}"
       V="-v"
    fi
    chown ${V} "${LMS_USER}" "${LMS_CFG}"
    chown ${V} -R -h "${LMS_USER}" "${LMS_CFG}/"
    chmod +x /config "${LMS_CFG}"
    ls -lad "${LMS_CFG}"
    ls -la "${LMS_CFG}"
    ls -la "${LMS_CACHE}"
fi

