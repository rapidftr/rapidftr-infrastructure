#
# Cookbook Name:: core
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# 'apt-get update' is required before installing packages
execute "apt-get-update" do
  command "apt-get update"
end

package "build-essential" do
  action :install
  options "--no-install-recommends --yes --force-yes"
end

package "git" do
  action :install
  options "--no-install-recommends --yes --force-yes"
end

package "openjdk-7-jdk" do
  action :install
  options "--no-install-recommends --yes --force-yes"
end

package "libxml2-dev" do
  action :install
  options "--no-install-recommends --yes --force-yes"
end

package "libxslt1-dev" do
  action :install
  options "--no-install-recommends --yes --force-yes"
end

package "imagemagick" do
  action :install
  options "--no-install-recommends --yes --force-yes"
end

package "zlib1g-dev" do
  action :install
  options "--no-install-recommends --yes --force-yes"
end

package "nodejs" do
  action :install
  options "--no-install-recommends --yes --force-yes"
end
