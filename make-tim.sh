#!/usr/bin/env sh

WHO=/tim

stat $WHO > /dev/null || (echo You must mount a file to "$WHO" in order to properly assume user && exit 1)

USERID=$(stat -c %u $WHO)
GROUPID=$(stat -c %g $WHO)

deluser --remove-home tim > /dev/null 2>&1

USERNAME=$(getent passwd "$USERID" | cut -d: -f1)
if [ ! -z ${USERNAME} ]; then
  deluser --remove-home $USERNAME > /dev/null 2>&1
fi

GROUPNAME=$(getent group "$GROUPID" | cut -d: -f1)
if [ ! -z ${GROUPNAME} ]; then
  delgroup $GROUPNAME > /dev/null 2>&1
fi

addgroup -g $GROUPID tim
adduser -u $USERID -G tim -D -s /bin/sh tim

gosu tim "$@"
