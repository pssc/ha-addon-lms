#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: lms
# Set up env from ha
# ==============================================================================

echo -n ${HAA_NAME:-$(hostname -s|sed 's/.*-//')} >/run/s6/container_environment/HAA_NAME
bashio::info.hostname >/run/s6/container_environment/HAA_HOST

exit 0
