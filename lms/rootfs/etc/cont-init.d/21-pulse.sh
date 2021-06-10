#!/usr/bin/with-contenv bashio
# ==============================================================================
bashio::log.info " Fix pulse perms"
# work round real ad effective uid issues in squeezeserver
chmod +x /root
mkdir -p /root/.config/pulse
chown 1000 /root/.config /root/.config/pulse
chmod 700 /root/.config /root/.config/pulse
