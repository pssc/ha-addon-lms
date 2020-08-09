#!/usr/bin/with-contenv bashio
# ==============================================================================
# Start udev service
# ==============================================================================
if [ "${UDEV:-false}" != "true" ]; then
   exit 0
fi

UDEVD=/sbin/udevd
if [ ! -x "${UDEVD}" ];then
   UDEVD=/lib/systemd/systemd-udevd
fi

"${UDEVD}" --daemon || true
bashio::log.info "Update udev information"
if udevadm trigger; then
    udevadm settle || true
else
    bashio::log.warning "Triggering of udev rules fails!"
fi
