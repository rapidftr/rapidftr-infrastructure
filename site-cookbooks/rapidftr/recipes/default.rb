#
# Cookbook Name:: rapidftr
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'docker'

directory "/data/#{node.rapidftr.instance}" do
  action :create
  recursive true
end

docker_image node.rapidftr.image do
  action :pull
  tag node.rapidftr.tag
  cmd_timeout 30*60
  notifies :redeploy, "docker_container[#{node.rapidftr.image}]"
end

docker_container node.rapidftr.image do
  action :run
  tag node.rapidftr.tag
  container_name node.rapidftr.instance
  port [ '80:80', '443:443', '6984:6984' ]
  volume "/data/#{node.rapidftr.instance}:/data"
  detach true
end
