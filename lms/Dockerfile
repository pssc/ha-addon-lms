ARG BUILD_FROM=hassioaddons/debian-base:latest

# ARGS...

FROM ${BUILD_FROM} AS base

ENV DEBIAN_FRONTEND "noninteractive"

RUN mv /init /s6init

# Upgrading the operating system inside the container
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold" && apt-get --no-install-recommends --no-install-suggests -qq -y install wget git rsync patch && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

FROM base AS builder
ARG BUILD_ARCH

RUN apt-get -qq -y update && \
    apt-get --no-install-recommends --no-install-suggests -qq -y install \
    patch rsync nasm make gcc g++ libc-bin zlib1g-dev libgd-dev libmodule-install-perl bzip2 build-essential pkg-config file libjpeg-dev && \
    mkdir -p /tmp/sources && \
    cd /tmp/sources && \
    git clone --depth 1 https://github.com/Logitech/slimserver-vendor -b public/8.0 && \
    mkdir -p tmp && \
    cd slimserver-vendor/CPAN && \
    mkdir -p build/include build/lib && \
    if [ "${BUILD_ARCH}" = "i386" ];then \
    ln -s /usr/include/jpeglib.h build/include/jpeglib.h && \
    ln -s /usr/include/*/jconfig.h build/include/jconfig.h && \
    ln -s /usr/lib/*/libjpeg.a build/lib/libjpeg.a \
    ; fi && \
    TMPDIR=/tmp/sources/tmp ./buildme.sh && \
    mkdir -p /usr/share/squeezeboxserver/CPAN/arch/$(basename build/arch/*)/ && \
    cp -vr build/arch/*/*/ /usr/share/squeezeboxserver/CPAN/arch/$(basename build/arch/*)/

FROM base

ARG url="http://www.mysqueezebox.com/update/?version=8.0&revision=1&geturl=1&os=deb"
ARG purl="http://downloads.slimdevices.com/LogitechMediaServer_v8.2.0/logitechmediaserver_8.2.0_all.deb"
ARG debug=false
ARG target_uid=1000
ARG BUILD_ARCH

ENV S6_SERVICES_GRACETIME 119000
ENV DISABLE_HA_AUTHENTICATION true

# Debug?
# LMS
ENV LMS_PREFS /config/lms/prefs
ENV LMS_PLUGS /config/lms/plugins
ENV LMS_CACHE /config/lms/cache
ENV LMS_LOGDIR /config/lms/logs
#ENV LMS_LOGFILE stdout
ENV LMS_OPTIONS " "
ENV LMS_USER "squeezeboxserver"
ENV LMS_GROUP "nogroup"
ENV HA_USER "squeezeboxserver"
ENV debug ${debug}

COPY rootfs/ /

RUN apt-get -qq -y update && \
        ls -la /tmp/ && \
	apt-get -qq -y install --no-install-recommends --no-install-suggests \
		faad \
		flac \
		lame \
		sox \
		libio-socket-ssl-perl \
		nfs-common \
		awscli \
		lvm2 \
		exfat-fuse \
		exfat-utils \
		sshfs \
		cifs-utils \
		tzdata && \
		apt-get install --no-install-recommends -qy wget curl perl tzdata libwww-perl libfont-freetype-perl liblinux-inotify2-perl libdata-dump-perl libio-socket-ssl-perl libnet-ssleay-perl libcrypt-ssleay-perl libcrypt-openssl-rsa-perl lame && \
		apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Debug packages
RUN if [ "${debug}" = "true " ];then apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold" && apt-get --no-install-recommends --no-install-suggests -qq -y install vim-tiny procps && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;fi

RUN echo "Download url: ${url}" && \
	cd /tmp && \
        xlatest_lms=$(wget -q -O - "${url}" | sed 's/_all\.deb/_'$(arch | sed 's/arm.*/arm/' | sed 's/x86_64/amd64/' | sed 's/aarch64/arm/')'\.deb/') && \
        latest_lms=$(echo "${purl}" | sed 's/_all\.deb/_'$(echo ${BUILD_ARCH} | sed 's/arm.*/arm/' | sed 's/x86_64/amd64/' | sed 's/aarch64/arm/')'\.deb/') && \
	if [ $latest_lms = $latest_lms ];then  echo $latest_lms != $latest_lms ;sleep 600;fi && \
	wget -nv $latest_lms && \
	lms_deb=${latest_lms##*/} && \
	dpkg -i $lms_deb && \
        if [[ $(id -u squeezeboxserver) != ${target_uid} ]];then usermod -u $target_uid squeezeboxserver ;fi && \
	id squeezeboxserver && \
        rm -rf /var/lib/squeezeboxserver && \
	rm /usr/share/squeezeboxserver/Plugins && \
	ln -s ${LMS_PLUGS} /usr/share/squeezeboxserver/Plugins && \
	rm $lms_deb && \
	ls -la /usr/share/squeezeboxserver/CPAN/arch/* && \
	rm -rf /usr/share/squeezeboxserver/CPAN/arch/* && \
	touch /usr/share/squeezeboxserver/Bin/deleteme && \
	cd /usr/share/squeezeboxserver/Bin/ && rm -r $(ls -1 /usr/share/squeezeboxserver/Bin/| grep -v $(arch|sed 's/arm.*/arm/'))

COPY --from=builder /usr/share/squeezeboxserver/CPAN/arch/ /usr/share/squeezeboxserver/CPAN/arch/
RUN ls -la /usr/share/squeezeboxserver/CPAN/arch/*

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

# Nginx Ingress support
RUN apt-get -qq -y update && \
    apt-get install -y --no-install-recommends \
        libnginx-mod-http-lua \
        luarocks \
        nginx && \
        luarocks install lua-resty-http 0.15-0 && \
        rm -r /etc/nginx && \
    apt-get autoremove && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY rootfs-ingress/ /

# osync
RUN cd /tmp && git clone --depth 1 -b "stable" https://github.com/deajan/osync && cd osync && bash install.sh --no-stats && cd /tmp && rm -r /tmp/osync

# hass-cli
RUN apt-get -qq -y update && \
    apt-get install -y --no-install-recommends python3-pip python3-setuptools python3-dev python3-wheel gcc && \
    apt-get install -y --no-install-recommends python3-jsonpath-rw python3-regex python3-requests python3-aiohttp python3-tabulate python3-netdisco python3-jinja2 python3-dateparser python3-ruamel.yaml python3-click python3-click-log && \
    pip3 install homeassistant-cli && \
    apt-get autoremove && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#pip3 show homeassistant-cli | grep Requires | sed 's/.*: /python3-/' | sed 's/, / python3-/g'
# apt-get remove python3-dev gcc \

# squeezy
RUN apt-get -qq -y update && \
    apt-get install -y --no-install-recommends libjson-rpc-perl && \
    cd /tmp && git clone --depth 1 -b "master" https://github.com/pssc/squeezy && cd squeezy && cp squeezy /usr/local/bin/ && cd /tmp && rm -r /tmp/squeezy && \
    apt-get autoremove && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Patching
RUN for i in /patch/*.patch;do patch -d / -p1 -i $i;done && rm -r /patch

#Cleanup
RUN if [ -z "${debug}" -o "${debug}" = "false" ];then apt-get -y remove \
        git \
        wget && \
	apt-get -y autoremove && \
        apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
        rm -fr /sources \
    ;fi

#VOLUME /data
#VOLUME /share
#VOLUME /backup
#VOLUME /config
#VOLUME /ssl
#VOLUME /media

# Build arguments
ARG BUILD_ARCH
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
