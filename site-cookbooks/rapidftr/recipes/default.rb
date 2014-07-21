# Setup RapidFTR from git source

node.override["rapidftr"]["release_env_dir"] = File.join node.rapidftr.release_base_dir, node.rapidftr.host
node.override["rapidftr"]["release_dir"] = File.join node.rapidftr.release_env_dir, 'current'
node.override["rapidftr"]["cert_dir"] = File.join node.rapidftr.nginx_cert_conf, node.rapidftr.host

group 'www-data' do
  action :modify
end

user 'www-data' do
  action :modify
  gid 'www-data'
end

[ "", "shared", "shared/log", "shared/pids", "shared/gems", "shared/solrdata" ].each do |dir|
  directory "#{node.rapidftr.host}-rapidftr-shared-#{dir}" do
    owner 'www-data'
    group 'www-data'
    mode '0755'
    path File.join(node.rapidftr.release_env_dir, dir)
    recursive true
  end
end

deploy_revision "#{node.rapidftr.host}-rapidftr-git" do
  repo node.rapidftr.repository
  revision node.rapidftr.revision
  deploy_to node.rapidftr.release_env_dir
  keep_releases 1
  user "www-data"
  group "www-data"
  shallow_clone true
  symlinks "pids" => "tmp/pids", "log" => "log", "gems" => "vendor/bundle", "solrdata" => "solr/data"
  environment "RAILS_ENV" => node.rapidftr.rails_env
end

template "#{node.rapidftr.host}-rails-environment" do
  source "rails-environment.erb"
  path File.join(node.rapidftr.release_dir, 'config', 'environments', node.rapidftr.rails_env + '.rb')
  owner "www-data"
  group "www-data"
  mode 0644
  variables node.rapidftr.to_hash
end

execute "xyz-path" do
  command "echo $PATH"
  cwd node.rapidftr.release_dir
  environment "RAILS_ENV" => node.rapidftr.rails_env
  path [ "/usr/local/rvm/bin" ]
  user "www-data"
  group "www-data"
end

execute "#{node.rapidftr.host}-bundle-install" do
  command "bundle install --deployment --without=development,test,cucumber"
  cwd node.rapidftr.release_dir
  environment "RAILS_ENV" => node.rapidftr.rails_env
  path [ "/usr/local/rvm/bin" ]
  user "www-data"
  group "www-data"
end

execute "#{node.rapidftr.host}-rake-couchdb-config" do
  command "bundle exec rake 'db:create_couchdb_yml[#{node.rapidftr.couchdb_username}, #{node.rapidftr.couchdb_password}]'"
  environment "RAILS_ENV" => node.rapidftr.rails_env
  cwd node.rapidftr.release_dir
  path [ "/usr/local/rvm/bin" ]
  user "www-data"
  group "www-data"
end

execute "#{node.rapidftr.host}-rake-couchdb-migrate" do
  command "bundle exec rake db:seed db:migrate"
  environment "RAILS_ENV" => node.rapidftr.rails_env
  cwd node.rapidftr.release_dir
  path [ "/usr/local/rvm/bin" ]
  user "www-data"
  group "www-data"
end

execute "#{node.rapidftr.host}-rake-asset-precompile" do
  command "bundle exec rake assets:clean assets:precompile"
  environment "RAILS_ENV" => node.rapidftr.rails_env
  cwd node.rapidftr.release_dir
  path [ "/usr/local/rvm/bin" ]
  user "www-data"
  group "www-data"
end

template "#{node.rapidftr.host}-nginx-site" do
  source "nginx-site.erb"
  path File.join(node.rapidftr.nginx_site_conf, node.rapidftr.host + '.conf')
  owner "www-data"
  group "www-data"
  mode 0644
  variables node.rapidftr.to_hash
end

directory "#{node.rapidftr.host}-nginx-ssl" do
  user "www-data"
  owner "www-data"
  mode 0440
  path node.rapidftr.cert_dir
  recursive true
end

cookbook_file "#{node.rapidftr.host}-certificate.crt" do
  source "certificate.crt"
  path File.join(node.rapidftr.cert_dir, "certificate.crt")
  owner "www-data"
  group "www-data"
  mode  0440
  ignore_failure true
end

cookbook_file "#{node.rapidftr.host}-certificate.key" do
  source "certificate.key"
  path File.join(node.rapidftr.cert_dir, "certificate.key")
  owner "www-data"
  group "www-data"
  mode 0440
  ignore_failure true
end

file "nginx-default-localhost" do
  path File.join(node.rapidftr.nginx_site_conf, "default")
  action :delete
end

service "nginx" do
  action :restart
end

template "#{node.rapidftr.host}-init-script" do
  source "init-script.erb"
  path File.join("/etc/init", "rapidftr-#{node.rapidftr.host}.conf")
  owner "root"
  group "root"
  mode 0644
  variables node.rapidftr.to_hash
  notifies :restart, "service[rapidftr-#{node.rapidftr.host}]", :immediately
end

service "rapidftr-#{node.rapidftr.host}" do
  action :restart
  provider Chef::Provider::Service::Upstart
end
