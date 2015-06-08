!include x64.nsh

ShowInstDetails hide
ShowUninstDetails hide

Name "RapidReg"
Caption "RapidReg"

OutFile "setup.exe"

SetDateSave on
SetDatablockOptimize on
CRCCheck on
SilentInstall normal

InstallDir "$PROGRAMFILES\RapidReg\RapidReg"

Var DataDir
Var vmname
Var running
Var previous_installation

;Installing Virtualbox
Section "Installing RapidReg"
    SetOutPath $INSTDIR
    SetRegView 64
    ;LogSet on

    ReadRegStr $1 HKLM "SOFTWARE\Oracle\VirtualBox" "InstallDir"
    ${If} $1 == ""
        ;File /a "VirtualBox.exe"
        CopyFiles /SILENT $EXEDIR\support\VirtualBox.exe $INSTDIR
        EXecWait '"$INSTDIR\VirtualBox.exe" --msiparams REBOOT=ReallySuppress'
    ${EndIf}

    StrCpy $DataDir "$INSTDIR\data"
    StrCpy $vmname "winrapidreg"

    ReadRegStr $0 HKLM "SOFTWARE\Oracle\VirtualBox" "InstallDir"

    nsExec::Exec '"$0\VBoxManage.exe" controlvm $vmname poweroff'
    nsExec::Exec '"$0\VBoxManage.exe" unregistervm --delete $vmname'

    CopyFiles /SILENT $EXEDIR\support\winrapidreg.ova $INSTDIR\winrapidreg.ova
    nsExec::Exec '"$0\VBoxManage.exe" import winrapidreg.ova'
    nsExec::Exec '"$0\VBoxManage.exe" modifyvm $vmname --natpf1 "http,tcp,0.0.0.0,80,,80"'
    nsExec::Exec '"$0\VBoxManage.exe" modifyvm $vmname --natpf1 "https,tcp,0.0.0.0,443,,443"'
    nsExec::Exec '"$0\VBoxManage.exe" modifyvm $vmname --natpf1 "couchdb_rep,tcp,0.0.0.0,5984,,5984"'
    nsExec::Exec '"$0\VBoxManage.exe" modifyvm $vmname --natpf1 "couchdb_rep,tcp,0.0.0.0,6984,,6984"'
    nsExec::Exec '"$0\VBoxManage.exe" startvm $vmname --type headless'

    ;create start-menu items
    CreateDirectory "$SMPROGRAMS\RapidReg"
    CreateShortCut "$SMPROGRAMS\RapidReg\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "$INSTDIR\Uninstall.exe" 0 SW_SHOWNORMAL
    WriteUninstaller $INSTDIR\Uninstall.exe

    ;WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Run" "WinRapidReg" "$\"$0\VBoxManage.exe$\" startvm $vmname --type headless"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Run" "WinRapidReg" "$\"$INSTDIR\start.bat$\""
    ;Write a batch file for starting the vm when the user logs in. put the file in the startup folder.

    Delete "$INSTDIR\start.bat"
    FileOpen $9 "$INSTDIR\start.bat" w
    FileWrite $9 "@ECHO OFF"
    FileWrite $9 "$\r$\n"
    FileWrite $9 'START /B cmd.exe /C ""$0\VBoxManage.exe" startvm $vmname --type headless" > "$TEMP\rapidreg_log.txt" 2>&1'
    FileWrite $9 "$\r$\n"
    FileClose $9

    CreateShortCut "$SMSTARTUP\StartRapidReg.lnk" "$INSTDIR\start.bat" "" "$INSTDIR\start.bat" 0 SW_SHOWNORMAL
    CreateShortCut "$SMPROGRAMS\RapidReg\StartRapidReg.lnk" "$INSTDIR\start.bat" "" "$INSTDIR\start.bat" 0 SW_SHOWNORMAL

    FileOpen $9 "$INSTDIR\stop.bat" w
    FileWrite $9 "@ECHO OFF"
    FileWrite $9 "$\r$\n"
    FileWrite $9 'START /B cmd.exe /C ""$0\VBoxManage.exe" controlvm $vmname poweroff" > "$TEMP\rapidreg_log.txt" 2>&1'
    FileWrite $9 "$\r$\n"
    FileClose $9

    CreateShortCut "$SMPROGRAMS\RapidReg\StopRapidReg.lnk" "$INSTDIR\stop.bat" "" "$INSTDIR\stop.bat" 0 SW_SHOWNORMAL

    ;registry entry for the add/remove programs in the control panel
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\RapidReg" "DisplayName" "RapidReg - Child Registration"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\RapidReg" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""

SectionEnd

UninstallText "This will uninstall RapidReg"

Section "Uninstall"
    ;LogSet on
    StrCpy $vmname "winrapidreg"
    ReadRegStr $0 HKLM "SOFTWARE\Oracle\VirtualBox" "InstallDir"
    nsExec::Exec '"$0\VBoxManage.exe" controlvm $vmname poweroff'

    ;remove the installation directory
    RMDir /r /REBOOTOK "$PROGRAMFILES\RapidReg"

    ;remove the startmenu directory for the application
    SetShellVarContext current
    Delete "$SMPROGRAMS\RapidReg\*.*"
    RMDir /r /REBOOTOK "$SMPROGRAMS\RapidReg"
    Delete "$SMSTARTUP\StartRapidReg.lnk"

    SetShellVarContext all
    Delete "$SMPROGRAMS\RapidReg\*.*"
    RMDir /r /REBOOTOK "$SMPROGRAMS\RapidReg"
    Delete "$SMSTARTUP\StartRapidReg.lnk"

    DeleteRegValue HKLM "Software\Microsoft\Windows\CurrentVersion\Run" "WinRapidReg"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\RapidReg"

    nsExec::Exec '"$0\VBoxManage.exe" unregistervm --delete $vmname'
SectionEnd

Function .onInstSuccess
    MessageBox MB_OK "You have successfully installed RapidReg"
FunctionEnd

Function un.onUninstSuccess
  MessageBox MB_OK "You have successfully uninstalled RapidReg."
FunctionEnd
