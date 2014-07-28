#
# Cookbook Name:: core
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "couchdb" do
  action :install
  options "--no-install-recommends --yes --force-yes"
end

cookbook_file "/etc/couchdb/local.d/rapidftr.ini" do
  source "local.ini"
  owner "couchdb"
  group "couchdb"
  mode 0755
end
