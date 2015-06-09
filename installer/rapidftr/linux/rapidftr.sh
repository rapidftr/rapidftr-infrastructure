#!/bin/bash
### BEGIN INIT INFO
#
# Provides : rapidftr
# Required-Start : $remote_fs
# Required-Stop  : $remote_fs
# Default-Start     : 2 3 4 5
# Default-Stop      : 0 1 6
# Short-Description : RapidFTR
# Description : Program that start the RapidFTR docker containers
#               This file should be used to construct scripts to be placed in /etc/init.d.
#
### END INIT INFO

PROG="rapidftr"
DATADIR="/data/rapidftr"
DOCKER_IMAGE_DIR="/rapidftr/"


start() {
  DOCKER_IMAGE_ID=$(docker images | grep -e 'rapidftr/rapidftr' | sed -E 's/rapidftr\/rapidftr *latest *([0-9a-z]+) *.*/\1/g')
  if [ -z $DOCKER_IMAGE_ID ]; then
    docker load < $DOCKER_IMAGE_DIR/rapidftr-image.tar.gz
  fi

  DOCKER_CONTAINER_ID=$(docker ps -aq -f 'name=rapidftr')

  if [ -z $DOCKER_CONTAINER_ID ]; then
    docker run -d -v $DATADIR:/data -e RAILS_ENV=production -e ENQUIRIES_FEATURE=on -p 80:80 -p 443:443 -p 6984:6984 -p 5984:5984 -t --name rapidftr rapidftr/rapidftr:latest
  else
    docker start $PROG
  fi

  echo "$PROG started"
}

stop() {
    docker stop rapidftr
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
