#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: lms
# Set up env from ha
# ==============================================================================

HAA_NAME="lms"
echo -n ${HAA_NAME} >/run/s6/container_environment/HAA_NAME

exit 0
