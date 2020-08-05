#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: lms
# Set up env from ha
# ==============================================================================

echo -n ${HAA_NAME:-$(hostname -s|sed 's/.*-//')} >/run/s6/container_environment/HAA_NAME

exit 0
