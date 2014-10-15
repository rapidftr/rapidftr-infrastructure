!include x64.nsh

ShowInstDetails hide
ShowUninstDetails hide

Name "RapidFTR"
Caption "RapidFTR"

OutFile "rapidftr.exe"

SetDateSave on
SetDatablockOptimize on
CRCCheck on
SilentInstall normal

InstallDir "$PROGRAMFILES\RapidFTR\RapidFTR2.0"
Var DataDir
Var vmname

;Installing Virtualbox
Section "Installing VirtualBox"
    SetOutPath $INSTDIR

    ReadRegStr $0 HKLM "SOFTWARE\Oracle\VirtualBox" "InstallDir"
    ${If} $0 == ""
        File /a "VirtualBox.exe"
        EXecWait '"$INSTDIR\VirtualBox.exe" --msiparams REBOOT=ReallySuppress'
    ${EndIf}
SectionEnd

Section "Installing Virtual Machine"
    StrCpy $DataDir "$INSTDIR\data"
    StrCpy $vmname "swindowsinstaller"

    ReadRegStr $0 HKLM "SOFTWARE\Oracle\VirtualBox" "InstallDir"

    Var /GLOBAL previous_installation

    ExecWait '"$0\VBoxManage.exe" list vms | findstr /R /C:"$vmname"' $previous_installation

    ${If} $previous_installation <> ""
        Var /GLOBAL running
        ExecWait '"$0\VBoxManage.exe" list runningvms | findstr /R /C:"$vmname"' $running

        ${If} $running <> ""
            ExecWait '"$0\VBoxManage.exe" controlvms $vmname poweroff'
        ${EndIf}

        ExecWait '"$0\VBoxManage.exe" unregistervm $vmname --delete'
    ${EndIf}

    File /a "winrapidftr.ova"
    ExecWait '"$0\VBoxManage.exe" import winrapidftr.ova'
    ExecWait '"$0\VBoxManage.exe" startvm $vmname --type headless'

    ;attach a shared directory to the virtual machine
    CreateDirectory "$DataDir"
    ExecWait '"$0\VBoxManage.exe" sharedfolder add $vmname --name /data/rapidftr --hostpath $DataDir'
SectionEnd
