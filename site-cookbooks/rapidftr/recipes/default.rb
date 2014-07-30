# TODO: Random ordering errors with the "stop/remove/redeploy"
# Sometimes it says "remove failed because container is still running"
# Whereas "stop" should have already happened!
# Need to follow up on chef-docker

include_recipe 'docker'

directory "/data/#{node.rapidftr.instance}" do
  action :create
  recursive true
end

docker_image node.rapidftr.image do
  action :pull
  tag node.rapidftr.tag
  cmd_timeout 30*60
  notifies :redeploy, "docker_container[#{node.rapidftr.instance}]", :immediately
end

docker_container node.rapidftr.instance do
  action :run
  image node.rapidftr.image
  tag node.rapidftr.tag
  container_name node.rapidftr.instance
  port %w(80:80 443:443 6984:6984)
  volume "/data/#{node.rapidftr.instance}:/data"
  detach true
  force true
  cmd_timeout 10*60
end

execute "docker-clean-unused-images" do
  action :run
  command "docker images | grep -e '^<none>' | sed -E 's/<none> *<none> *([0-9a-z]+) *.*/\\1/g' | xargs -I {} docker rmi {}"
  ignore_failure true
end
