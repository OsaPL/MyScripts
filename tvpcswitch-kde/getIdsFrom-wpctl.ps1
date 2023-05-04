# I CANT BE BOTHERED TO MAKE BASH REGEXES WORK SO ITS POWERSHELL SCRIPT

Write-Output "Searching for" $args[0]
$toFind = $args[0]
Write-Output ""

# Gets whole status
$temp = wpctl status | Out-File -FilePath temp.txt
$cmdOut = (Get-Content -Path temp.txt -Raw)
$temp = Remove-Item temp.txt

#Seperate the "Audio: Sinks:" part
$temp = $cmdOut -match '(?ms)^Audio.+?Sinks:(.+?)├─'
$audioPart = $Matches[1]

# Find all sinks
$sinks = $audioPart | Select-String -Pattern '(?si)\s(\d+?).\s+(.+?)\s+\[' -AllMatches
$i = 0;
$sinks.Matches | ForEach-Object {
    Write-Output $_.Groups[1].Value
    Write-Output $_.Groups[2].Value
    Write-Output "sink $i -----------------"
    Write-Output ""
    $i++
    
    if($toFind -eq $_.Groups[2].Value)
    {
        Write-Output "Found! Switching to:" $_.Groups[1].Value
        wpctl set-default $_.Groups[1].Value 
        exit
    }
}


