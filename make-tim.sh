#!/usr/bin/env sh

WHO=/tim

stat $WHO > /dev/null || (echo You must mount a file to "$WHO" in order to properly assume user && exit 1)

USERID=$(stat -c %u $WHO)
GROUPID=$(stat -c %g $WHO)

deluser --remove-home tim > /dev/null 2>&1

GROUPNAME=$(getent group "$GROUPID" | cut -d: -f1)
if [ -z ${GROUPNAME} ]; then
  addgroup -g $GROUPID tim
  GROUPNAME=tim
fi

USERNAME=$(getent passwd "$USERID" | cut -d: -f1)
if [ -z ${USERNAME} ]; then
  adduser -u $USERID -G $GROUPNAME -D -s /bin/sh tim
  USERNAME=tim
else
  if [ -z $(id -gn "$USERNAME" | grep "$GROUPNAME") ]; then
    adduser $USERNAME $GROUPNAME
  fi
fi



gosu $USERNAME "$@"
