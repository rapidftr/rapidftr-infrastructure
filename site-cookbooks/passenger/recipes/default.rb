#
# Cookbook Name:: passenger
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "python-software-properties" do
  action :install
  options "--no-install-recommends --yes --force-yes"
end

package "apt-transport-https" do
  action :install
  options "--no-install-recommends --yes --force-yes"
end

package "ca-certificates" do
  action :install
  options "--no-install-recommends --yes --force-yes"
end

execute "passenger-apt-key" do
  command "apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7"
end

file "/etc/apt/sources.list.d/passenger.list" do
  content "deb https://oss-binaries.phusionpassenger.com/apt/passenger precise main"
  owner "root"
  group "root"
  mode 0600
  notifies :run, "execute[apt-get-update]", :immediately
end

package "nginx-extras" do
  action :install
  options "--no-install-recommends --yes --force-yes"
end

package "passenger" do
  action :install
  options "--no-install-recommends --yes --force-yes"
end

cookbook_file "/etc/nginx/conf.d/passenger.conf" do
  source "passenger.conf"
  owner "root"
  group "root"
  mode 0664
end

service "nginx" do
  action :enable
end
