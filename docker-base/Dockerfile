FROM phusion/passenger-full:0.9.11

ENV HOME /root
ENTRYPOINT ["/sbin/my_init"]

# Provision
ADD image/provision.sh /root/provision.sh
RUN /root/provision.sh

# CouchDB
ADD image/config/couchdb.ini /etc/couchdb/local.d/rapidftr.ini
ADD image/runit/couchdb/ /etc/service/couchdb/
EXPOSE 5984
EXPOSE 6984

# Nginx
ADD image/config/nginx-site.conf /etc/nginx/sites-enabled/default

# Services
ADD image/runit/solr/ /etc/service/solr/
ADD image/runit/scheduler/ /etc/service/scheduler/

# CouchDB Credentials
ADD image/couch_credentials.sh /etc/my_init.d/00_couch_credentials.sh
