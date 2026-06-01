#!/usr/bin/with-contenv bashio
# ==============================================================================
# Install user configured/requested packages
# ==============================================================================
if bashio::config.true 'upgrade_packages'; then
   bashio::log.info " Updating package lists"
   apt-get update \
        || bashio::.log.error 'Failed updating packages repository indexes'

   if [ "$(bashio::config 'upgrade_packages')" = "true" ];then
        apt-get -y -o Dpkg::Options::="--force-confold" dist-upgrade \
            || bashio::log.error 'Failed updating packages'
   fi
fi


if bashio::config.has_value 'packages'; then
   bashio::log.info " Updating package lists"
   apt-get update \
        || bashio::.log.error 'Failed updating packages repository indexes'

   for package in $(bashio::config 'packages'); do
        bashio::log.info " Installing package ${package}"
        apt-get install -y --no-install-suggests --no-install-recommends -o Dpkg::Options::="--force-confold" "$package" \
		|| ( bashio::log.error "Failed installing package ${package}" ;bashio::exit.nok "Failed installing package ${package}" )
   done
   bashio::log.info " Installed user configured/requested packages"
fi

if bashio::config.has_value 'local_packages'; then
   bashio::log.info " installing local packages"

   ( cd ${DEB_PKG_DIR}
   for package in *.deb; do
        bashio::log.info " Installing package ${package}"
        apt-get install -y --no-install-suggests --no-install-recommends -o Dpkg::Options::="--force-confold" -f "$package" \
		|| ( bashio::log.error "Failed installing package ${package}" ;bashio::exit.nok "Failed installing package ${package}" )
   done
   )
   bashio::log.info " Installed local packages"
fi
