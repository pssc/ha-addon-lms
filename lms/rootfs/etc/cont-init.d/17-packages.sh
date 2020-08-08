#!/usr/bin/with-contenv bashio
# ==============================================================================
# Install user configured/requested packages
# ==============================================================================
if bashio::config.has_value 'packages'; then
   bashio::log.info " Installing user configured/requested packages"
   apt-get update \
        || bashio::exit.nok 'Failed updating Alpine packages repository indexes'

    for package in $(bashio::config 'packages'); do
        apt-get install -y --no-install-suggests --no-install-recommends  "$package" \
            || bashio::exit.nok "Failed installing package ${package}"
    done
fi
