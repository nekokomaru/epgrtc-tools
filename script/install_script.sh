#!/bin/bash

DEST=/usr/local/bin
DEST_CONF=/usr/local/etc

GETRESERVED=getreserved
GETENCODING=getencoding
GETSMBLOCK=getsmblock
SETALARM=setalarm
SETALARM_CONF=setalarm.conf
SHUTDOWN=shutdown
SHUTDOWN_SRV=shutdown_srv
GETLOGINUSR=getloginusr
BASH_ALIASES=.bash_aliases
WAKEDFOREPG=wakedforepg.txt
WAITEPG=waitepg

if [ ! -z "$1" ] && [ "$1" = 'install' ]; then

  echo "install scripts."

  if [ -f ${GETRESERVED} ]; then
    sudo install ${GETRESERVED} ${DEST}
  fi
  if [ -f ${GETENCODING} ]; then
    sudo install ${GETENCODING} ${DEST}
  fi
  if [ -f ${GETSMBLOCK} ]; then
    sudo install ${GETSMBLOCK} ${DEST}
  fi
  if [ -f ${SETALARM} ]; then
    sudo install ${SETALARM} ${DEST}
  fi
  if [ -f ${SETALARM_CONF} ]; then
    sudo install -m 644 ${SETALARM_CONF} ${DEST_CONF}
  fi
  if [ -f ${SHUTDOWN} ]; then
    sudo install ${SHUTDOWN} ${DEST}
  fi
  if [ -f ${GETLOGINUSR} ]; then
    sudo install  ${GETLOGINUSR} ${DEST}
  fi
  if [ -f ${SHUTDOWN_SRV} ]; then
    sudo install ${SHUTDOWN_SRV} ${DEST}
  fi
  if [ -f ${WAITEPG} ]; then
    sudo install ${WAITEPG} ${DEST}
  fi

  # script
  echo 'install alias'
  if [ -f ${BASH_ALIASES} ]; then
    cat ${BASH_ALIASES} >> ${HOME}/${BASH_ALIASES}
    sudo bash -c "cat ${BASH_ALIASES} >> /root/${BASH_ALIASES}"
  fi

elif [ ! -z "$1" ] && [ "$1" = 'uninstall' ]; then

  echo 'uninstall scripts'

  if [ -f "${DEST}/${GETRESERVED}" ]; then
    sudo rm "${DEST}/${GETRESERVED}"
  fi
  if [ -f "${DEST}/${GETENCODING}" ]; then
    sudo rm "${DEST}/${GETENCODING}"
  fi
  if [ -f "${DEST}/${GETSMBLOCK}" ]; then
    sudo rm "${DEST}/${GETSMBLOCK}"
  fi
  if [ -f "${DEST}/${SETALARM}" ]; then
    sudo rm "${DEST}/${SETALARM}"
  fi
  if [ -f "${DEST_CONF}/${SETALARM_CONF}" ]; then
    sudo rm "${DEST_CONF}/${SETALARM_CONF}"
  fi
  if [ -f "${DEST}/${SHUTDOWN}" ]; then
    sudo rm "${DEST}/${SHUTDOWN}"
  fi
  if [ -f "${DEST}/${GETLOGINUSR}" ]; then
    sudo rm "${DEST}/${GETLOGINUSR}"
  fi
  if [ -f "${DEST}/${SHUTDOWN_SRV}" ]; then
    sudo rm "${DEST}/${SHUTDOWN_SRV}"
  fi
  if [ -f "${DEST_CONF}/${WAKEDFOREPG}" ]; then
    sudo rm "${DEST_CONF}/${WAKEDFOREPG}"
  fi
  if [ -f "${DEST}/${WAITEPG}" ]; then
    sudo rm "${DEST}/${WAITEPG}"
  fi

  # remove alias
  echo 'remove alias'

  if [ -f "${HOME}/${BASH_ALIASES}" ]; then
    PAT=`cat < .bash_aliases`
    sed -i -e "s/${PAT}//g" ${HOME}/${BASH_ALIASES}
    sudo sed -i -e "s/${PAT}//g" /root/${BASH_ALIASES}
  fi

fi
