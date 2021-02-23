#!/bin/bash

DEST_SERVICE=/etc/systemd/system

SETALARM=setalarm
WAITEPG=waitepg
SERVICE_EXT=.service

if [ ! -z "$1" ] && [ "$1" = 'install' ]; then

  # service
  echo 'install service'
#  if [ -f ${SETALARM}${SERVICE_EXT} ]; then
#    sudo install -m 644 ${SETALARM}${SERVICE_EXT} ${DEST_SERVICE}
#    sudo systemctl daemon-reload
#    sudo systemctl enable ${SETALARM}
#    sudo systemctl start ${SETALARM}
#  fi
  if [ -f ${WAITEPG}${SERVICE_EXT} ]; then
    sudo install -m 644 ${WAITEPG}${SERVICE_EXT} ${DEST_SERVICE}
    sudo systemctl daemon-reload
    sudo systemctl enable ${WAITEPG}
    sudo systemctl start ${WAITEPG}
  fi

elif [ ! -z "$1" ] && [ "$1" = 'uninstall' ]; then

  # uninstall service
  echo 'uninstall service'
#  sudo systemctl stop ${SETALARM}
#  sudo systemctl disable ${SETALARM}
#  if [ -f ${DEST_SERVICE}/${SETALARM}${SERVICE_EXT} ]; then
#    sudo rm ${DEST_SERVICE}/${SETALARM}${SERVICE_EXT}
#    sudo systemctl daemon-reload
#  fi

  sudo systemctl stop ${WAITEPG}
  sudo systemctl disable ${WAITEPG}
  if [ -f ${DEST_SERVICE}/${WAITEPG}${SERVICE_EXT} ]; then
    sudo rm ${DEST_SERVICE}/${WAITEPG}${SERVICE_EXT}
    sudo systemctl daemon-reload
  fi
fi
