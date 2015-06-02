#!/bin/bash
vagrant up --provision linux-rapidreg-dev && vagrant up --provision linux-rapidreg-test
vagrant halt linux-rapidreg-dev && vagrant halt linux-rapidreg-test && VBoxManage export winrapidreg -o windows/winrapidreg.ova

vagrant up --provision linux-rapidregwindows-installer && vagrant halt linux-rapidregwindows-installer
