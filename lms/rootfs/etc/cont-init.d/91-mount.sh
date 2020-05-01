#!/usr/bin/with-contenv bashio

LMS_MUSIC=${LMS_MUSIC:-"/data/music"}
LMS_USER=${LMS_USER:-"squeezeboxserver"}
MOUNT=$(bashio::config mount)

if [ ! -z "${MOUNT}" ];then
  mkdir -p ${LMS_MUSIC}
  chown ${LMS_USER} ${LMS_MUSIC}
  mount ${MOUNT} ${LMS_MUSIC}
fi
