SetTitleMatchMode, 2
#SingleInstance

; Counts the amount of resizes. Mostly used for debugging
Counter=0

; Sets Pre-Timer to 45, in case the user hits cancel to the prompt later on.
PreTimer=45

; Finds your screen's resolution to start the calculations. Will be modified later.
MCX = %A_ScreenWidth%
MCY = %A_ScreenHeight%

; Fixed value for the original screen resolution. Used in some calculations
OriginalX = %A_ScreenWidth%
OriginalY = %A_ScreenHeight%

; Initial fixed value for how many pixels to shrink the window each time. Biases to becoming a square so MC's UI remains useable.
DivideX := OriginalX/100
DivideY := OriginalY/105

; MCX and MCY is the new calculated size of the window.
MCX := MCX-(DivideX*3)
MCY := MCY-(DivideY*3)

; These values determine where the top-left most pixel of the window should be when the resize happens.
PosX := OriginalX-MCX
PosY := OriginalY-MCY

MsgBox, Minecraft...but the screen shrinks every minute or so. Hit OK when you are ready to begin! Please don't run Minecraft maximized, and definitely don't run it in full screen. An icon has appeared in your taskbar for this program. If you wish to quit at any time, close the prgram from there. -Made by youtube.com/AntVenom

InputBox, PreTimer, Timer,How many seconds between each window shrink? Every 45 seconds means it'll take about an hour to reach the smallest size. Every 90 seconds would take about 2 hours. Every 22 seconds would take about a half hour. Entering non-numbers may break the program. 0.1 makes it go very fast.,,,,,,,,45

Timer := PreTimer*1000

if WinExist("ahk_exe javaw.exe",,"Launcher")
	WinActivate

ToolTip, Resizing in 5
sleep 1000
ToolTip, Resizing in 4
sleep 1000
ToolTip, Resizing in 3
sleep 1000
ToolTip, Resizing in 2
sleep 1000
ToolTip, Resizing in 1
sleep 1000
ToolTip, 

	if WinActive("ahk_exe javaw.exe",,"Launcher")
	{
		; This bit of math determines where to position the window so it stays centered
		PosX := ((OriginalX-MCX)/2)
		PosY := ((OriginalY-MCY)/2)
		PosY := PosY-(DivideY*1)

		; Shrinks and moves the window, then activates it, just in case.
		WinMove,,, PosX, PosY, MCX, MCY
		WinActivate
	}

	ToolTip, Initial window size set. Have fun!
	sleep 3000

; The main loop. Resizes and re-centers the Minecraft window until the Windows Y size becomes less than 170 (Check end of script).
Loop
{
	; The main sleep function. This will determine how often the window resizes.
	ToolTip,
	sleep %Timer%

	; This sub-loop checks to see if Minecraft is selected, since it has to be for the resizing to work.
	Loop
	{
		if WinActive("ahk_exe javaw.exe",,"Launcher")
			break
		else
		{
		MsgBox,1,, Minecraft is not currently active. Resizing paused. Please select it to continue, or cancel to close the program!
		IfMsgBox Cancel
			ExitApp

		ToolTip, Resuming in 3
		sleep 1000
		ToolTip, Resuming in 2
		sleep 1000
		ToolTip, Resuming in 1
		sleep 1000
		ToolTip, 
		}
	}

	; Moves and resizes Minecraft game if it's selected
	if WinActive("ahk_exe javaw.exe",,"Launcher")
	{
		; This bit of math determines where to position the window so it stays centered
		PosX := ((OriginalX-MCX)/2)
		PosY := ((OriginalY-MCY)/2)

	; This little bit of code biases the window's position up a few pixels to avoid cutting into the start menu. Stops after 5 cycles.
	if Counter<5
	{
		PosY := PosY-(DivideY-1)
	}
		; Shrinks and moves the window, then activates it, just in case.
		WinMove,,, PosX, PosY, MCX, MCY
		WinActivate
	}

	; Determines the next window size.
	MCX:=MCX-DivideX
	MCY:=MCY-DivideY

	; Once the window becomes too small, the program ends. Becomes smaller a LITTLE faster at certain resolutions.
	if (MCY<170)
		break

	Counter:=Counter+1

}

ToolTip, Final window size achieved! Resized %Counter% times! Have fun!
sleep 5000
ToolTip,