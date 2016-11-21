:: Simple script to delete bloatware and bloatware in Win 10.
::	If you dont wanna delete something, just delete anything between its name and next one
::	e.g to keep Windows Defender
::	:: Windows Defender
::	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f  <<Delete those two lines
::	install_wim_tweak /o /c Windows-Defender /r 															<<
::	:: Windows Store
::	by Osa__PL, feel free to improve, share, just mke sure to credit me.

@echo off
setlocal enabledelayedexpansion
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------   

:: Deleting all unnecessary apps/services

:: Windows Defender
choice /m "Do you want to delete Windows Defender?"
IF ERRORLEVEL 1 (
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
	install_wim_tweak /o /c Windows-Defender /r
)
IF ERRORLEVEL 2 (
	echo "Not deleting Windows Defender"
)

:: Windows Store
choice  /m "Do you want to delete Windows Store?"
IF ERRORLEVEL 1 (
	powershell -command "Get-AppxPackage *store* | Remove-AppxPackage"
	install_wim_tweak /o /c Microsoft-Windows-ContentDeliveryManager /r
	reg add "HKLM\Software\Policies\Microsoft\WindowsStore" /v RemoveWindowsStore /t REG_DWORD /d 1 /f
	reg add "HKLM\Software\Policies\Microsoft\WindowsStore" /v DisableStoreApps /t REG_DWORD /d 1 /f
)
IF ERRORLEVEL 2 (
	echo "Not deleting Windows Store"
)

:: Zune media player
choice  /m "Do you want to delete Zune media player?"
IF ERRORLEVEL 1 (
	powershell -command "Get-AppxPackage *zune* | Remove-AppxPackage"
)
IF ERRORLEVEL 2 (
	echo "Not deleting Zune media player"
)

:: Xbox app
choice  /m "Do you want to delete the Xbox app?"
IF ERRORLEVEL 1 (
	powershell -command "Get-AppxPackage *xbox* | Remove-AppxPackage"
	powershell -command "Get-AppxPackage -AllUsers *xbox* | Remove-AppxPackage"
	install_wim_tweak /o /c Microsoft-Xbox-GameCallableUI /r
	sc delete XblAuthManager
	sc delete XblGameSave
	sc delete XboxNetApiSvc
	:: Just to be 100% sure
	reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
	reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f
)
IF ERRORLEVEL 2 (
	echo "Not deleting the Xbox app"
	choice  /m "Do you want to disable GameDVR?"
	IF ERRORLEVEL 1 (
		:: Disabling GameDVR (only necessary if you dont delete the xbox app)
		reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
		reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f
	)
	IF ERRORLEVEL 2 (
		echo "Not disabling GameDVR"
	)
)


:: Stickynotes
choice  /m "Do you want to delete Stickynotes?"
IF ERRORLEVEL 1 (
	powershell -command "Get-AppxPackage *sticky* | Remove-AppxPackage"
)
IF ERRORLEVEL 2 (
	echo "Not deleting Stickynotes"
)

:: Maps and location tracking
choice  /m "Do you want to delete Maps app and tracking services?"
IF ERRORLEVEL 1 (
	powershell -command "Get-AppxPackage *maps* | Remove-AppxPackage"
	sc delete MapsBroker
	sc delete lfsvc
)
IF ERRORLEVEL 2 (
	echo "Not deleting Maps app and tracking services"
)


::Misc apps
choice  /m "Do you want to delete Alarms?"
IF ERRORLEVEL 1 (
	powershell -command "Get-AppxPackage *alarms* | Remove-AppxPackage"
)
IF ERRORLEVEL 2 (
	echo "Not deleting Alarms"
)

choice  /m "Do you want to delete Contacts?"
IF ERRORLEVEL 1 (
	powershell -command "Get-AppxPackage *people* | Remove-AppxPackage"
)
IF ERRORLEVEL 2 (
	echo "Not deleting Contacts"
)

choice  /m "Do you want to delete Record app?"
IF ERRORLEVEL 1 (
	powershell -command "Get-AppxPackage *soundrec* | Remove-AppxPackage"
)
IF ERRORLEVEL 2 (
	echo "Not deleting Record app"
)

choice  /m "Do you want to delete Bing search?"
IF ERRORLEVEL 1 (
	powershell -command "Get-AppxPackage *bing* | Remove-AppxPackage"
)
IF ERRORLEVEL 2 (
	echo "Not deleting Bing search"
)

choice  /m "Do you want to delete Photos app?"
IF ERRORLEVEL 1 (
	powershell -command "Get-AppxPackage *photo* | Remove-AppxPackage"
)
IF ERRORLEVEL 2 (
	echo "Not deleting Photos app"
)

choice  /m "Do you want to delete Calendar app?"
IF ERRORLEVEL 1 (
	powershell -command "Get-AppxPackage *comm* | Remove-AppxPackage"
)
IF ERRORLEVEL 2 (
	echo "Not deleting Calendar app"
)

choice  /m "Do you want to delete Calendar app?"
IF ERRORLEVEL 1 (
	powershell -command "Get-AppxPackage *comm* | Remove-AppxPackage"
)
IF ERRORLEVEL 2 (
	echo "Not deleting Calendar app"
)

choice  /m "Do you want to delete OneNote?"
IF ERRORLEVEL 1 (
	powershell -command "Get-AppxPackage *onenote* | Remove-AppxPackage"
)
IF ERRORLEVEL 2 (
	echo "Not deleting OneNote"
)

choice  /m "Do you want to delete Messages app?"
IF ERRORLEVEL 1 (
	powershell -command "Get-AppxPackage *mess* | Remove-AppxPackage"
	sc delete MessagingService
	sc delete MessagingService_xxxxx
)
IF ERRORLEVEL 2 (
	echo "Not deleting Messages app"
)

::Support and PPI services
install_wim_tweak /o /c Microsoft-Windows-ContactSupport /r
install_wim_tweak /o /c Microsoft-PPIProjection-Package /r

:: Disable Cortana
choice  /m "Do you want to disable Cortana?"
IF ERRORLEVEL 1 (
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f
)
IF ERRORLEVEL 2 (
	echo "Not disabling Cortana"
)

:: Disable Account sync (doesnt matter if youre not using an MS account)
reg add "HKLM\Software\Policies\Microsoft\Windows\SettingSync" /v DisableSettingSync /t REG_DWORD /d 1 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\SettingSync" /v DisableSettingSyncUserOverride /t REG_DWORD /d 1 /f

:: Disabling hints
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /v DisableSoftLanding /t REG_DWORD /d 1 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsSpotlightFeatures /t REG_DWORD /d 1 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v DoNotShowFeedbackNotifications /t REG_DWORD /d 1 /f

::Uninstalling one drive
choice  /m /m "Do you want to delete OneDrive (reboot is needed to finalize)"
IF ERRORLEVEL 1 (
	taskkill /F /IM onedrive.exe
	"%SYSTEMROOT%\SysWOW64\OneDriveSetup.exe" /uninstall
	sc delete OneSyncSvc
	sc delete OneSyncSvc_xxxxx
	::Copy one time script to autostart
	copy "%CD%\afterreboot.bat" "%AppData%\Microsoft\Windows\Start Menu\Programs\Startup\autodestruct.bat"
	echo "After next reboot a script will run."
	echo "LET IT RUN, it is a one time only thing."
)
IF ERRORLEVEL 2 (
	echo "Not deleting OneDrive"
)

:: Removing Telemetry and other unnecessary services
sc delete DiagTrack
sc delete dmwappushservice
sc delete WerSvc
sc delete CDPUserSvc
sc delete CDPUserSvc_xxxxx


