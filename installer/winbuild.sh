#!/bin/bash
vagrant up --provision linux-dev && vagrant up --provision linux-test
vagrant halt linux-dev && vagrant halt linux-test && VBoxManage export winrapidftr -o windows/winrapidftr.ova

vagrant up --provision linux-windows-installer && vagrant halt linux-windows-installer




