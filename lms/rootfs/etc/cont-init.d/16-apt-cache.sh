#!/usr/bin/with-contenv bashio
# ==============================================================================
# Install user configured/requested packages
# ==============================================================================

#if bashio::config.true 'upgrade_packages'; then
#if bashio::config.true 'cache_packages'; then
#if bashio::config.has_value 'packages'; then

if [ -r "${LMS_HACFGDIR}/apt" ];then
        bashio::log.info " Using addon cachedir ${LMS_HACFGDIR}/apt for /var/cache/apt"
        rm /etc/apt/apt.conf.d/docker-clean
	cat >/etc/apt/apt.conf.d/keep <<EOF
APT::Keep-Downloaded-Packages "true";
EOF

	rm -rf /var/cache/apt
	ln -s "${LMS_HACFGDIR}/apt" /var/cache/apt
fi

exit 0
