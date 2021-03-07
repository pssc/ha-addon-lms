ARG BUILD_FROM=hassioaddons/debian-base:latest
FROM ${BUILD_FROM}
ARG target_uid=1000
ARG url="http://www.mysqueezebox.com/update/?version=7.9&revision=1&geturl=1&os=deb"
ARG surl="http://www.mysqueezebox.com/update/?version=8.0&revision=1&geturl=1&os=nocpan"
ARG purl="http://downloads.slimdevices.com/LogitechMediaServer_v7.9.3/logitechmediaserver_7.9.3_all.deb"
ARG debug=false

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

RUN mv /init /s6init
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
		patch \
		exfat-fuse \
		exfat-utils \
		tzdata

#FIXME DEV?
RUN if [[ ! -z "${debug}" ]];then apt-get -y install --no-install-recommends vim less procps strace ;fi

RUN mkdir -p /sources/lms/packages

# Query for last version
RUN echo "${url}" && \
        latest_lms=$(wget -q -O - "${url}" | sed 's/_all\.deb/_'$(arch | sed 's/arm.*/arm/' | sed 's/x86_64/amd64/' | sed 's/aarch64/arm/')'\.deb/') && \
	cd /sources && \
	echo $latest_lms && \
	wget $latest_lms && \
	lms_deb=${latest_lms##*/} && \
	dpkg -i $lms_deb && \
	apt-get -y install --no-install-recommends nasm make gcc rsync patch g++ libc-bin zlib1g-dev libgd-dev libmodule-install-perl bzip2 && \
	cd /sources && \
	git clone --depth 1 https://github.com/Logitech/slimserver-vendor -b public/8.0 && \
	mkdir -p tmp && \
	cd slimserver-vendor/CPAN && \
	TMPDIR=/sources/tmp ./buildme.sh && \
	rm -rf /usr/share/squeezeboxserver/CPAN/arch/* && \
	cp -vr build/arch/*/*/ /usr/share/squeezeboxserver/CPAN/arch/$(basename build/arch/*)/ && \
	apt-get -y remove nasm make gcc g++ zlib1g-dev libgd-dev libmodule-install-perl bzip2  && \
        cd /tmp && rm -rf /sources/slimserver-vendor

#eg. http://downloads.slimdevices.com/LogitechMediaServer_v7.9.3/logitechmediaserver_7.9.3_arm.deb
# Copy script and run Script?
#RUN echo "${purl}" && \
#        latest_lms=$(echo $purl | sed 's/_all\.deb/_'$(arch | sed 's/arm.*/arm/')'\.deb/') && \
#	cd /sources/lms/packages && \
#	wget $latest_lms && \
#	lms_deb=${latest_lms##*/} && \
#	dpkg -i $lms_deb
#        latest_lms=$(wget -q -O - "${surl}") && \
#        echo $latest_lms && \
#	cd /sources && \
#        wget $latest_lms && \

# Clean Up and repoint
RUN rm -rf /var/lib/squeezeboxserver && \
	rm /usr/share/squeezeboxserver/Plugins && \
	ln -s ${LMS_PLUGS} /usr/share/squeezeboxserver/Plugins

# Add user.
RUN if [[ $(id -u squeezeboxserver) != ${target_uid} ]];then usermod -u $target_uid squeezeboxserver ;fi

# Nginx Ingress support
RUN apt-get install -y --no-install-recommends \
        libnginx-mod-http-lua \
        luarocks \
        nginx \
    && luarocks install lua-resty-http 0.15-0 \
    && rm -r /etc/nginx
COPY rootfs-ingress/ /

RUN cd /sources && git clone --depth 1 -b "stable" https://github.com/deajan/osync && cd osync && bash install.sh --no-stats && cd /tmp && rm -r /sources/osync

RUN apt-get install -y --no-install-recommends python3-pip python3-setuptools python3-dev python3-wheel gcc && \
    apt-get install -y --no-install-recommends python3-jsonpath-rw python3-regex python3-requests python3-aiohttp python3-tabulate python3-netdisco python3-jinja2 python3-dateparser python3-ruamel.yaml python3-click python3-click-log && \
   pip3 install homeassistant-cli
#pip3 show homeassistant-cli | grep Requires | sed 's/.*: /python3-/' | sed 's/, / python3-/g'

RUN apt-get install -y --no-install-recommends libjson-rpc-perl && \
    cd /sources && git clone --depth 1 -b "master" https://github.com/pssc/squeezy && cd squeezy && cp squeezy /usr/local/bin/ && cd /tmp && rm -r /sources/squeezy

COPY patch /sources/
RUN for i in /sources/*.patch;do patch -d / -p1 -i $i;done

#Cleanup
RUN if [ -z "${debug}" -o "${debug}" = "false" ];then apt-get -y remove \
        git \
        wget && \
	apt-get clean -y && \
	apt-get -y autoremove && \
        rm -r /sources && \
	rm -r /var/lib/apt/lists/*;fi

#RUN rm -r /tmp && ln -s /tmpfs /tmp
#ENV TEMP /tmpfs/
#ENV TMP /tmpfs/
#ENV TMPDIR /tmpfs/
#ENV TEMPDIR /tmpfs/

VOLUME /data
VOLUME /share
VOLUME /backup
VOLUME /config
VOLUME /ssl
VOLUME /media

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
