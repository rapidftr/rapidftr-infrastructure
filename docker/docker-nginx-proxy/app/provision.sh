#!/bin/bash
set -xe

export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive
minimal_apt_get_install='apt-get install -y --no-install-recommends'

# PAM conflicts with users on Host machine!
#   https://github.com/dotcloud/docker/issues/6345#issuecomment-49245365
#   This workaround is required temporarily, can be removed after
#   Docker Hub kernel is upgraded or issue is fixed
ln -s -f /bin/true /usr/bin/chfn
alias adduser='useradd'

apt-get update --yes
$minimal_apt_get_install nginx wget ca-certificates
echo "daemon off;" >> /etc/nginx/nginx.conf

# docker-gen
wget https://github.com/jwilder/docker-gen/releases/download/0.3.2/docker-gen-linux-amd64-0.3.2.tar.gz -O - | tar xvz
mv docker-gen /usr/local/bin

# forego for running procfile
wget -P /usr/local/bin https://godist.herokuapp.com/projects/ddollar/forego/releases/current/linux-amd64/forego
chmod u+x /usr/local/bin/forego

# cleanup
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /build/ $0
