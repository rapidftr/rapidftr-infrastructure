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
Var running
Var previous_installation

;Installing Virtualbox
Section "Installing RapidFTR"
    SetOutPath $INSTDIR
    SetRegView 64
    ;LogSet on

    ReadRegStr $1 HKLM "SOFTWARE\Oracle\VirtualBox" "InstallDir"
    ${If} $1 == ""
        File /a "VirtualBox.exe"
        EXecWait '"$INSTDIR\VirtualBox.exe" --msiparams REBOOT=ReallySuppress'
    ${EndIf}

    StrCpy $DataDir "$INSTDIR\data"
    StrCpy $vmname "winrapidftr"

    ReadRegStr $0 HKLM "SOFTWARE\Oracle\VirtualBox" "InstallDir"

    nsExec::Exec '"$0\VBoxManage.exe" controlvm $vmname poweroff'
    nsExec::Exec '"$0\VBoxManage.exe" unregistervm --delete $vmname'

    File /a "winrapidftr.ova"
    nsExec::Exec '"$0\VBoxManage.exe" import winrapidftr.ova'
    nsExec::Exec '"$0\VBoxManage.exe" modifyvm $vmname --natpf1 "http,tcp,0.0.0.0,80,,80"'
    nsExec::Exec '"$0\VBoxManage.exe" modifyvm $vmname --natpf1 "https,tcp,0.0.0.0,443,,443"'
    nsExec::Exec '"$0\VBoxManage.exe" startvm $vmname --type headless'

    ;create start-menu items
    CreateDirectory "$SMPROGRAMS\RapidFTR"
    CreateShortCut "$SMPROGRAMS\RapidFTR\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "$INSTDIR\Uninstall.exe" 0 SW_SHOWNORMAL
    WriteUninstaller $INSTDIR\Uninstall.exe

    ;WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Run" "WinRapidFTR" "$\"$0\VBoxManage.exe$\" startvm $vmname --type headless"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Run" "WinRapidFTR" "$\"$INSTDIR\start.bat$\""
    ;Write a batch file for starting the vm when the user logs in. put the file in the startup folder.

    Delete "$INSTDIR\start.bat"
    FileOpen $9 "$INSTDIR\start.bat" w
    FileWrite $9 "@ECHO OFF"
    FileWrite $9 "$\r$\n"
    FileWrite $9 'START /B cmd.exe /C ""$0\VBoxManage.exe" startvm $vmname --type headless" > "$TEMP\rapidftr_log.txt" 2>&1'
    FileWrite $9 "$\r$\n"
    FileClose $9

    CreateShortCut "$SMSTARTUP\StartRapidFTR.lnk" "$INSTDIR\start.bat" "" "$INSTDIR\start.bat" 0 SW_SHOWNORMAL
    CreateShortCut "$SMPROGRAMS\RapidFTR\StartRapidFTR.lnk" "$INSTDIR\start.bat" "" "$INSTDIR\start.bat" 0 SW_SHOWNORMAL

    FileOpen $9 "$INSTDIR\stop.bat" w
    FileWrite $9 "@ECHO OFF"
    FileWrite $9 "$\r$\n"
    FileWrite $9 'START /B cmd.exe /C ""$0\VBoxManage.exe" controlvm $vmname poweroff" > "$TEMP\rapidftr_log.txt" 2>&1'
    FileWrite $9 "$\r$\n"
    FileClose $9

    CreateShortCut "$SMPROGRAMS\RapidFTR\StopRapidFTR.lnk" "$INSTDIR\stop.bat" "" "$INSTDIR\stop.bat" 0 SW_SHOWNORMAL
SectionEnd

UninstallText "This will uninstall RapidFTR"

Section "Uninstall"
    ;LogSet on
    StrCpy $vmname "winrapidftr"
    ReadRegStr $0 HKLM "SOFTWARE\Oracle\VirtualBox" "InstallDir"
    nsExec::Exec '"$0\VBoxManage.exe" controlvm $vmname poweroff'
    nsExec::Exec '"$0\VBoxManage.exe" unregistervm --delete $vmname'

    ;delete all files from the installation directory
    RMDir /r "$INSTDIR\*.*"

    ;remove the installation directory
    RMDir /r $INSTDIR
    RMDir /r "$PROGRAMFILES\RapidFTR"

    ;remove the startmenu directory for the application
    Delete "$SMPROGRAMS\RapidFTR\*.*"
    RMDir /r "$SMPROGRAMS\RapidFTR"

    DeleteRegValue HKLM "Software\Microsoft\Windows\CurrentVersion\Run" "WinRapidFTR"
    Delete "$SMSTARTUP\winrapidftr.bat"
SectionEnd

Function .onInstSuccess
    MessageBox MB_OK "You have successfully installed RapidFTR"
FunctionEnd

Function un.onUninstSuccess
  MessageBox MB_OK "You have successfully uninstalled RapidFTR."
FunctionEnd
