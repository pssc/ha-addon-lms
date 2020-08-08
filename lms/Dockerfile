ARG BUILD_FROM=hassioaddons/debian-base:latest
FROM ${BUILD_FROM}
ARG target_uid=1000
ARG url="http://www.mysqueezebox.com/update/?version=7.9&revision=1&geturl=1&os=deb" 
ARG debug=true

ARG BUILD_ARCH

# ARGS...

#FIX From Arg.
# env
# Allow longer shutdown
ENV S6_SERVICES_GRACETIME 119000
# Set for package install
ENV DEBIAN_FRONTEND "noninteractive" 
# FIXME? locales
#ENV LANG C.UTF-8
# TZ config at runtime
ENV DISABLE_HA_AUTHENTICATION true

# LMS 
# Debug?
ENV LMS_PREFS /config/lms/prefs
ENV LMS_PLUGS /config/lms/plugins
ENV LMS_CACHE /config/lms/cache
ENV LMS_LOGDIR /config/lms/logs
#ENV LMS_LOGFILE stdout
ENV LMS_OPTIONS " "
ENV LMS_USER "squeezeboxserver"
ENV LMS_GROUP "nogroup"
ENV HA_USER "squeezeboxserver"
ENV UDEV true

COPY rootfs/ /

RUN apt-get update && \
	apt-get -y install --no-install-recommends \
		curl \
		wget \
		faad \
		flac \
		lame \
		sox \
		rsync \
		libio-socket-ssl-perl \
		git \
		nfs-common \
		udev \
		awscli \
		lvm2 \
		tzdata 

#FIXME DEV?
RUN if [[ ! -z "${debug}" ]];then apt-get -y install vim less procps strace;fi

#FIXME user curl
RUN echo "${url}" && \
        latest_lms=$(wget -q -O - "${url}" | sed 's/_all\.deb/_'$(arch | sed 's/arm.*/arm/')'\.deb/') && \
	mkdir -p /sources && \
	cd /sources && \
	wget $latest_lms && \
	lms_deb=${latest_lms##*/} && \
	dpkg -i $lms_deb && \
	rm -rf /var/lib/squeezeboxserver && \
	rm /usr/share/squeezeboxserver/Plugins && \
	ln -s ${LMS_PLUG} /usr/share/squeezeboxserver/Plugins
RUN if [[ $(id -u squeezeboxserver) != ${target_uid} ]];then usermod -u $target_uid squeezeboxserver ;fi

# Nginx Ingress support
RUN apt-get install -y --no-install-recommends \
        libnginx-mod-http-lua \
        luarocks \
        nginx \
    && luarocks install lua-resty-http 0.15-0 \
    && rm -r /etc/nginx

COPY rootfs-ingress/ /

RUN cd /sources && git clone -b "stable" https://github.com/deajan/osync && cd osync && bash install.sh --no-stats

#Cleanup
RUN if [ -z "${debug}" -o "${debug}" = "false" ];then apt-get -y remove \
           git \
           wget && \
	apt-get clean -y && \
	apt-get -y autoremove && \
        rm -r /sources ;fi


VOLUME /data
VOLUME /share
VOLUME /backup
VOLUME /config
VOLUME /ssl
VOLUME /tmpfs

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="lms" \
    io.hass.description="Logitech Media Server, SqueezeBox Server / UPNP Media Server" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Phillip Camp <phillip.camp+ha<removeme>@gmail.com>" \
    org.label-schema.description="Logitech Media Server, SqueezeBox Server / UPNP Media Server" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="lms" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.usage="https://github.com/pssc/ha-addon-lms/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/pssc/ha-addon-lms" \
    org.label-schema.vendor="pssc"

#    org.label-schema.url="https://community.home-assistant.io/t/home-assistant-community-add-on-portainer/68836?u=frenck" \
