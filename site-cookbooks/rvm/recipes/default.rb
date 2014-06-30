#
# Cookbook Name:: rvm
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "curl" do
  action :install
end

file "/etc/gemrc" do
  action :create
  owner "root"
  group "root"
  mode 0644
  content "gem: --no-ri --no-rdoc"
end

execute "install-rvm" do
  command "sudo sh -c 'curl -L https://get.rvm.io | bash -s -- --auto-dotfiles'"
  not_if { ::File.exists? "/usr/local/rvm/bin/rvm" }
end

execute "rvm-ruby-2.1.2" do
  command "sudo sh -c '/usr/local/rvm/bin/rvm install ruby-2.1.2'"
  not_if { ::File.exists? "/usr/local/rvm/rubies/ruby-2.1.2/bin/ruby" }
end

file "/etc/profile.d/ruby-opts.sh" do
  action :delete
end
