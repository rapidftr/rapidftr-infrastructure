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

execute "rvm-ruby-1.9.3" do
  command "sudo sh -c '/usr/local/rvm/bin/rvm install 1.9.3-p392'"
  not_if { ::File.exists? "/usr/local/rvm/rubies/ruby-1.9.3-p392/bin/ruby" }
end

file "/etc/profile.d/ruby-opts.sh" do
  action :create
  owner "root"
  group "root"
  mode 0755
  content "export RUBY_HEAP_MIN_SLOTS=2000000 RUBY_HEAP_FREE_MIN=20000 RUBY_GC_MALLOC_LIMIT=100000000"
end
