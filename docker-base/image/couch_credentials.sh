#!/usr/bin/env bash
#Generate random username/password for CouchDB

password=$(uuidgen | tr -d '-')
username=$(uuidgen | tr -d '-')
echo -e "[admins]\n$username = $password" > /etc/couchdb/local.d/rapidftr-security.ini

cd /rapidftr
bundle exec rake db:create_couchdb_yml[$username,$password]
chown -R www-data:www-data .
