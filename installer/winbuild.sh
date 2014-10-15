#!/bin/bash

vagrant reload --provision linux-dev && vagrant reload --provision linux-test
vagrant halt linux-dev && vagrant halt linux-test && VBoxManage export winrapidftr -o windows/winrapidftr.ova

vagrant reload --provision linux-windows-installer && vagrant halt linux-windows-installer




