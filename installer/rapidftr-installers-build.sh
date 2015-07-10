#!/bin/bash
#BASEDIR=$(dirname $0)
BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
if [ ! -f Vagrantfile ]; then
  echo "Missing Vagrantfile"
  exit 1;
fi

echo "-------------------------- starting installer box ------------------------------"
vagrant up --provision rapidftr-installers

echo "--------------------------- packaging linux offline installer ------------------"
vagrant halt rapidftr-installers

INSTALLER_FILE=$BASEDIR/rapidftr-linux-installer.tar.gz

[ -f $INSTALLER_FILE ] && rm $INSTALLER_FILE

tar czf $INSTALLER_FILE -C $BASEDIR/rapidftr/linux/ .

echo "--------------------------- packaging windows installer -----------------------"
mkdir -p $BASEDIR/rapidftr/windows/support/

if [ -f $BASEDIR/rapidftr/windows/support/winrapidreg.ova ]; then
    rm $BASEDIR/rapidftr/windows/support/winrapidreg.ova;
fi

VBoxManage export winrapidftr -o $BASEDIR/rapidftr/windows/support/winrapidftr.ova

if [ ! -f $BASEDIR/rapidftr/windows/support/Virtualbox.exe ]; then
  wget -O $BASEDIR/rapidftr/windows/support/Virtualbox.exe http://download.virtualbox.org/virtualbox/4.3.28/VirtualBox-4.3.28-100309-Win.exe
fi

INSTALLER_FILE=$BASEDIR/rapidftr-windows-installer.tar.gz

[ -f $INSTALLER_FILE ] && rm $INSTALLER_FILE

tar czf $INSTALLER_FILE --exclude='*.nsi' -C $BASEDIR/rapidftr/windows/ .

echo "------------------------------ done ------------------------------------------"
