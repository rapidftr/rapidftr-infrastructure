#!/bin/bash
BASEDIR=$(dirname $0)

if [ ! -f Vagrantfile ]; then
  echo "Missing Vagrantfile"
  exit 1;
fi

echo "-------------------------- starting installer box ------------------------------"
vagrant up --provision rapidreg-installers

echo "--------------------------- packaging linux offline installer ------------------"
vagrant halt rapidreg-installers

INSTALLER_FILE=$BASEDIR/rapidreg-linux-installer.tar.gz

[ -f $INSTALLER_FILE ] && rm $INSTALLER_FILE

tar czf $INSTALLER_FILE -C $BASEDIR/rapidreg/linux/ .

echo "--------------------------- packaging windows installer -----------------------"
if [ -f $BASEDIR/rapidreg/windows/support/winrapidreg.ova ]; then
    rm $BASEDIR/rapidreg/windows/support/winrapidreg.ova;
fi

VBoxManage export winrapidreg -o $BASEDIR/rapidreg/windows/support/winrapidreg.ova

if [ ! -f $BASEDIR/rapidreg/windows/support/Virtualbox.exe ]; then
  wget -O $BASEDIR/rapidreg/windows/support/Virtualbox.exe http://download.virtualbox.org/virtualbox/4.3.28/VirtualBox-4.3.28-100309-Win.exe
fi

INSTALLER_FILE=$BASEDIR/rapidreg-windows-installer.tar.gz

[ -f $INSTALLER_FILE ] && rm $INSTALLER_FILE

tar czf $INSTALLER_FILE --exclude='*.nsi' -C $BASEDIR/rapidreg/windows/ .

echo "------------------------------ done ------------------------------------------"
