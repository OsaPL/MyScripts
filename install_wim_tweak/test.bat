setlocal enabledelayedexpansion
choice /m "Do you want to delete Windows Defender?"
IF ERRORLEVEL 1 (
	echo "Deleting Windows Defender"
	echo "Deleting Windows Defender"
)
IF ERRORLEVEL 2 (
	echo "Not deleting Windows Defender"
	echo "Deleting Windows Defender"
)

choice /m "Do you want to delete Windows Defender?"
IF ERRORLEVEL 1 (
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
	install_wim_tweak /o /c Windows-Defender /r
)
IF ERRORLEVEL 2 (
	echo "Not deleting Windows Defender"
)
pause