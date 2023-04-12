#Requires AutoHotkey v2.0
#MaxThreadsPerHotkey 2

TraySetIcon("icon.png")

; Only for educational purposes! Dont use these!

; HighAlching
Toggle := false
StartTime := A_TickCount

MyGui := Gui()
MyGui.Opt("+AlwaysOnTop +Disabled +ToolWindow +Border")
MyGui.Add("Picture", "w300 h-1", "HA.png")
MyGui.BackColor := "EEAA99"
WinSetTransColor("EEAA99", MyGui)

HighAlch()
{
	Send "{Click}"
	if !Toggle{
		SetTimer 0
	}
	else {
		SetTimer HighAlch, Random(1500, 1700)
	}
	
	time := A_TickCount - StartTime
	MyGui.Title := time

	global StartTime := A_TickCount
}

F6::
{
    global Toggle := !Toggle
	If Toggle
	{
		MyGui.Show("x0 y0")
	} else {
		MyGui.Hide
	}
	period := Toggle ? Random(1500, 1700) : 0
	SetTimer HighAlch, period
	return
}

; Mouse4 to space
XButton1::
{
    Send "{Space}"
}

