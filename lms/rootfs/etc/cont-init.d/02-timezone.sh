#!/usr/bin/with-contenv bash

# Get docker env timezone and set system timezone
if [[ $(cat /etc/timezone) != "$TZ" ]] ; then
	echo "Setting the timezone to : $TZ"
	echo $TZ > /etc/timezone
	ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
	dpkg-reconfigure tzdata
	echo "Date: `date`"
fi
