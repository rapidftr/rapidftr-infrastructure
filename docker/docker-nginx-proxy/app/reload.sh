#!/bin/bash
set -xe

hosts=`cat /etc/nginx/sites-enabled/default | grep -E 'upstream (.+) \{' | sed -E 's/upstream (.+) \{/\\1/g'`
for host in $hosts; do
  # Check and create SSL key
  hostdir=/data/$host
  mkdir -p $hostdir
  chown -R root:root $hostdir

  if [ ! -f $hostdir/certificate.crt ]; then
    openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 -subj "/C=XX/ST=FIXME/L=FIXME/O=FIXME/CN=FIXME" -keyout $hostdir/certificate.key -out $hostdir/certificate.crt
  fi

  chmod 0700 $hostdir
  chmod 0600 $hostdir/*
done

nginx -s reload
