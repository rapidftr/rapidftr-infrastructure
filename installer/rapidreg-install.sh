SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname $SCRIPT)
DATADIR="/data/rapidreg"

install_docker() {
  echo "Checking if we can install Docker online..."
  if which wget; then
    wget -qO $BASEDIR/docker.sh https://get.docker.io
  elif which curl; then
    curl -sSL -o $BASEDIR/docker.sh https://get.docker.io
  fi

  if [ -s $BASEDIR/docker.sh ]; then
    echo "Installing Docker online..."
    chmod +x $BASEDIR/docker.sh
    sh $BASEDIR/docker.sh
  elif grep 'Ubuntu 14.04' /etc/lsb-release; then
    echo "Installing Docker offline..."
    dpkg -i $BASEDIR/apt/*.deb
  else
    echo "Please connect to the internet to install Docker online"
    echo "Or use Ubuntu 14.04 to install Docker offline"
    exit 1
  fi
}

check_requirements() {
  if [ $(id -u) != "0" ]; then
    echo "This installer needs to be run as root"
    exit 1
  fi

  if ! which docker; then
    echo "Docker is not installed, trying to install..."
    install_docker
  fi
}

remove_rapidreg() {
  echo "Removing old RapidReg..."
  docker ps -a | grep 'rapidreg' | cut -d' ' -f1 | xargs -I {} docker rm -f {}
}

install_rapidreg() {
  echo "Installing RapidReg..."
  docker import - rapidreg < rapidreg-image.tar.gz
  sudo cp -f $BASEDIR/rapidreg.sh /etc/init.d/rapidreg
  sudo chmod +=rwx /etc/init.d/rapidreg
  sudo update-rc.d rapidreg defaults
  docker run -d -v $DATADIR:/data -e RAILS_ENV=production -p 80:80 -p 443:443 -p 6984:6984 -t --name rapidreg rapidreg /sbin/my_init
  sudo /etc/init.d/rapidreg start
}

cleanup() {
  echo "Cleaning up..."
  docker ps -a  | grep 'Exited' | cut -d' ' -f1 | xargs -I {} docker rm {}
  docker images | grep -e '^<none>' | sed -E 's/<none> *<none> *([0-9a-z]+) *.*/\1/g' | xargs -I {} docker rmi {}
}

check_requirements
remove_rapidreg
install_rapidreg
cleanup
