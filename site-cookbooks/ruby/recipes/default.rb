#
# Cookbook Name:: ruby
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

file "/etc/gemrc" do
  owner "root"
  group "root"
  mode 0664
  action :create
  content "gem: --no-ri --no-rdoc"
end

execute "apt-add-repository-ruby" do
  command "apt-add-repository -y ppa:brightbox/ruby-ng"
  not_if "dpkg --get-selections | grep -q 'ruby2.1'"
  notifies :run, "execute[apt-get-update]", :immediately
end

package "ruby2.1" do
  action :install
  options "--no-install-recommends --yes --force-yes"
end

package "ruby2.1-dev" do
  action :install
  options "--no-install-recommends --yes --force-yes"
end

package "ruby-switch" do
  action :install
  options "--no-install-recommends --yes --force-yes"
end

execute "ruby-switch --set ruby2.1" do
end

execute "install-bundler" do
  command "gem2.1 install bundler --version '~> 1.6.3'"
end
