#!/usr/bin/with-contenv bashio
# ==============================================================================
# Install user configured/requested packages
# ==============================================================================
if bashio::config.true 'upgrade_packages'; then
   bashio::log.info " Updating package lists"
   apt-get update \
        || bashio::.log.error 'Failed updating packages repository indexes'

   if [ "$(bashio::config 'upgrade_packages')" = "true" ];then
        apt-get dist-upgrade \
            || bashio::log.error 'Failed updating packages'
   fi
fi


if bashio::config.has_value 'packages'; then
   bashio::log.info " Updating package lists"
   apt-get update \
        || bashio::.log.error 'Failed updating packages repository indexes'

   for package in $(bashio::config 'packages'); do
        bashio::log.info " Installing package ${package}"
        apt-get install -y --no-install-suggests --no-install-recommends  "$package" \
		|| ( bashio::log.error "Failed installing package ${package}" ;bashio::exit.nok "Failed installing package ${package}" )
   done
   bashio::log.info " Installing user configured/requested packages"
fi
