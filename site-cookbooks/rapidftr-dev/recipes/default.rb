# This is PURPOSEFULLY a single recipe, because all production
# provisioning is done by Docker, so this is actually an unnecessary burden
#
# In fact, I contemplated whether to use simple shell "apt-get ..." commands
# But added a recipe instead just for sake of some configuration files

execute "firefox-ppa" do
  command "apt-add-repository 'deb http://us.archive.ubuntu.com/ubuntu/ lucid-security main'"
end

execute "ruby-ppa" do
  command "add-apt-repository --yes ppa:brightbox/ruby-ng-experimental"
end

execute "apt-update" do
  command "apt-get update"
end

%w(build-essential git openjdk-7-jdk libxml2-dev libxslt1-dev imagemagick zlib1g-dev couchdb xfonts-cyrillic xfonts-100dpi xfonts-75dpi xfonts-scalable xvfb ruby2.1 ruby2.1-dev nodejs phantomjs curl wget).each do |pkg|
  package pkg do
    action :install
    options "--no-install-recommends --yes"
  end
end

package "firefox" do
  action :install
  version "20.0+build1-0ubuntu0.10.04.3"
  options "--no-install-recommends --yes"
end

package "couchdb" do
  action :install
  options "--no-install-recommends --yes"
end

cookbook_file "/etc/couchdb/local.d/rapidftr.ini" do
  source "couchdb.ini"
  owner "couchdb"
  group "couchdb"
  mode 0755
end

execute "restart-couchdb" do
  command "service couchdb restart"
end

file '/etc/gemrc' do
  content 'gem: --no-ri --no-rdoc'
  mode 0644
  owner 'root'
  group 'root'
end

execute 'bundler-install' do
  command 'gem install bundler'
end

file "/etc/profile.d/xvfb-display.sh" do
  content 'export DISPLAY=:99'
  mode 0755
  owner 'root'
  group 'root'
end

cookbook_file "/etc/init.d/xvfb" do
  source "xvfb"
  owner "root"
  group "root"
  mode 0755
end

service 'xvfb' do
  action [:enable, :start]
end

execute "bundle-install" do
  command "su vagrant -l -c 'cd /vagrant && bundle install --jobs 2'"
end

execute "copy-couch-config-yml-dev" do
  command "su vagrant -l -c 'cd /vagrant && bundle exec rake db:create_couchdb_yml[rapidftr,rapidftr]'"
end

execute "rake-app-migrate" do
  command "su vagrant -l -c 'cd /vagrant && bundle exec rake db:seed db:migrate'"
end

execute "sunspot-start" do
  command "su vagrant -l -c 'cd /vagrant && bundle exec rake sunspot:solr:start'"
end
