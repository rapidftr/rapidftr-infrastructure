# RapidFTR Infrastructure

This repository contains Scripts, Chef Cookbooks, Dockerfiles, etc. to setup RapidFTR infrastructure.

# TODO:

## RapidFTR Production:

* Add documentation for the certificates
  * https://devcenter.heroku.com/articles/ssl-certificate-self - The most succint self-signed SSL docs
* CouchDB certificate
* Auto-backup CouchDB data file
* Generate password automatically for couchdb.yml! Win FTW!
* CouchDB auto compaction (http://wiki.apache.org/couchdb/Compaction) and performance boost
* Certificate enhancements (e.g. not requiring certificate when upgrading)
* Auto-configuring backup instance

## CI:

* Cookbooks for configuring CI (Jenkins/TeamCity/...) and Agent
* Agent should have all necessary software installed as per the development/production setup
* Plan is to boot a docker container, provision the agent, take a snapshot and then start from the snapshot for running tests.
