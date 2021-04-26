function Write-ColorOutput($ForegroundColor)
{
    # save the current color
    $fc = $host.UI.RawUI.ForegroundColor

    # set the new color
    $host.UI.RawUI.ForegroundColor = $ForegroundColor

    # output
    if ($args) {
        Write-Output $args
    }
    else {
        $input | Write-Output
    }

    # restore the original color
    $host.UI.RawUI.ForegroundColor = $fc
}

"Enabling all monitors..." | Write-ColorOutput green 
# Enable all
"Enabling 1" | Write-ColorOutput yellow 
.\MultiMonitorTool.exe /enable 1
Start-Sleep 5
"Enabling 2" | Write-ColorOutput yellow 
.\MultiMonitorTool.exe /enable 2
Start-Sleep 5
"Enabling 3" | Write-ColorOutput yellow 
.\MultiMonitorTool.exe /enable 3
Start-Sleep 5

"Gathering monitor parameters..." | Write-ColorOutput green 
## Gather info
$devices = @{};

#Hardcoded placement
#$devices[0]= #AG241QG4
#$devices[1]= #SAMSUNG
#$devices[2]= #DELL U2412M

.\MultiMonitorTool.exe  /scomma test
Start-Sleep 5
$mytable = Import-Csv -Path test

foreach($r in $mytable)
{
    if($r.'Monitor Name'.Equals("AG241QG4")){
		"Parsing 1..." | Write-ColorOutput yellow 
        $devices[0]= $r
    }
    elseif($r.'Monitor Name'.Equals("SAMSUNG")){
		"Parsing 2..." | Write-ColorOutput yellow 
        $devices[1]= $r
    }
    elseif($r.'Monitor Name'.Equals("DELL U2412M")){
		"Parsing 3..." | Write-ColorOutput yellow 
        $devices[2]= $r
    }
}

"Preparing configs..." | Write-ColorOutput green 
## Replace values
Copy-Item pc pcTemp
$configPc = Get-Content -path pcTemp -Raw
$configPc = $configPc.Replace('0.Name', $devices[0].Name)
$configPc = $configPc.Replace('0.MonitorID', $devices[0].'Monitor ID')
$configPc = $configPc.Replace('2.Name', $devices[2].Name)
$configPc = $configPc.Replace('2.MonitorID', $devices[2].'Monitor ID')
Set-Content -Path pcTemp -Value $configPc
"PC config ready" | Write-ColorOutput yellow 

Copy-Item tv tvTemp
$configTv = Get-Content -path tvTemp -Raw
$configTv = $configTv.Replace('1.Name', $devices[1].Name)
$configTv = $configTv.Replace('1.MonitorID', $devices[1].'Monitor ID')
Set-Content -Path tvTemp -Value $configTv
"TV config ready" | Write-ColorOutput yellow 

"Initialising switching..." | Write-ColorOutput green 
## Switch
if(Test-Path PcMode)
{
	"Found PcMode, switching to TV..." | Write-ColorOutput yellow 
    #$intButton = $sh.Popup("Switching to TV Mode!\r\nPlease wait...",20,"Switcher",0+64)
	Remove-Item PcMode
    
    .\MultiMonitorTool.exe /disable $devices[2].Name
    Start-Sleep 5
    .\MultiMonitorTool.exe /disable $devices[0].Name
    #WHY THE FUCK DO I NEED TO LOAD THIS 2 TIMES?!
    .\MultiMonitorTool.exe /loadconfig tvTemp
    Start-Sleep 5
    .\MultiMonitorTool.exe /loadconfig tvTemp

	"Found PcMode, switching to TV..." | Write-ColorOutput yellow 
	# Start big picture
	Start-Process steamBigpicture.bat

	"Changing audio output" | Write-ColorOutput yellow 
    # Set audio output
    .\AudioSwitch.exe -s "1 - AG241QG4 (AMD High Definition Audio Device)"
    }
else
{
	"No PcMode found, switching to PC..." | Write-ColorOutput yellow 
	New-Item PcMode

    .\MultiMonitorTool.exe /disable $devices[1].Name
    Start-Sleep 5
    #WHY THE FUCK DO I NEED TO LOAD THIS 2 TIMES?!
    .\MultiMonitorTool.exe /loadconfig pcTemp
    Start-Sleep 5
    .\MultiMonitorTool.exe /loadconfig pcTemp

	"Changing audio output" | Write-ColorOutput yellow 
    # Set audio output
    .\AudioSwitch.exe -s "Speakers (2- Realtek(R) Audio)"
}

Remove-Item pcTemp
Remove-Item tvTemp
Remove-Item test

"DONE!" | Write-ColorOutput green 

Start-Sleep 20