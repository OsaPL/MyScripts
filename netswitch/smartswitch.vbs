'==================================================================
' 
' NAME:  Check Connection Type
' 
' AUTHOR: Mark Randol
' DATE  : 4/29/2015
' 
' COMMENT: this script will return
'          1 if the both are in use (shouldn't happen, but can)
'          2 if wired LAN adapter is in use
'          3 if wireless LAN adapter is in use
'          4 if none of the LAN adapters are in use.
'==================================================================

On Error Resume Next

Dim strComputer
Dim objWMIService
Dim colWiFi
Dim colLAN
Dim objWifi
Dim objLAN
Dim state
Dim wireStatus
Dim wifiStatus
Dim strOut
Dim intOutput

'===================================================================================
' Initialize Variables
'===================================================================================

intOutput = 4
state = ""
strComputer = "."
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2")
Set colLAN = objWMIService.ExecQuery("Select * From Win32_NetworkAdapter Where NetConnectionStatus = 2 and PhysicalAdapter = 'True'")

'==================================================================
' Enumerate the wired adapters in WMI.  Add 1 to output if wired adapter is in use.
'==================================================================

'Wscript.Echo("Output starting at " & intOutput)

For Each objLAN in colLAN
    strOut = objLAN.NetConnectionID & " " & objLAN.Name & " " & objLAN.PhysicalAdapter
    if instr(lcase(objLAN.Name),"virtual") = 0 and instr(lcase(objLAN.Name),"multiplex") = 0 and  instr(lcase(objLAN.Name),"bridge") = 0 then
       '==================================================================
' Above line (if statement) is there to eliminate other extraneous adapters that
' still show up even though we are eliminating all but "physical" adapters.  Some
' virtual adapters are still there, Microsoft being the biggest offender.
' Add to the line if necessary to remove other non-physical adapters.
'==================================================================

        if instr(lcase(objLAN.NetConnectionID),"wireless") > 0 or instr(lcase(objLAN.NetConnectionID),"wi-fi") > 0 then
            intOutput = intOutput - 2
            'Wscript.Echo(strOut & " connected.  Output is now " & intOutput)
        end if
        if instr(lcase(objLAN.NetConnectionID),"wireless") = 0 and instr(lcase(objLAN.NetConnectionID),"wi-fi") = 0 Then
            intOutput = intOutput - 1
            'Wscript.Echo(strOut & " connected.  Output is now " & intOutput)
        end if
    end if
next

'Wscript.Echo("Final Output = " & intOutput)

set shell=CreateObject("Shell.Application")

If intOutput <> 3 Then 
	shell.ShellExecute "testnet.bat",,, "runas", 0
Else
	shell.ShellExecute "wifinet.bat",,, "runas", 0
End If
set shell=nothing 