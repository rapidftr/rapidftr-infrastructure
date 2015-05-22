#!/bin/bash
### BEGIN INIT INFO
#
# Provides : rapidftr
# Required-Start : $remote_fs
# Required-Stop  : $remote_fs
# Default-Start     : 2 3 4 5
# Default-Stop      : 0 1 6
# Short-Description : RapidReg
# Description : Program that start the RapidReg docker containers
#               This file should be used to construct scripts to be placed in /etc/init.d.
#
### END INIT INFO

PROG="rapidreg"

start() {
    docker start $PROG
    echo "$PROG started"
}

stop() {
    docker stop $PROG
    echo "$PROG stopped"
}

## Check to see if we are running as root first.
## Found at http://www.cyberciti.biz/tips/shell-root-user-check-script.html
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

case "$1" in
    start)
        start
        exit 0
    ;;
    stop)
        stop
        exit 0
    ;;
    reload|restart|force-reload)
        stop
        start
        exit 0
    ;;
    **)
        echo "Usage: $0 {start|stop|reload}" 1>&2
        exit 1
    ;;
esac
