#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;============================== Start Auto-Execution Section ==============================

; Determines how fast a script will run (affects CPU utilization)
; The value -1 means the script will run at it's max speed possible
SetBatchLines, -1

; Avoids checking empty variables to see if they are environment variables
; Recommended for performance and compatibility with future AutoHotkey releases
#NoEnv

; Ensures that there is only a single instance of this script running
#SingleInstance, Force

; Makes a script unconditionally use its own folder as its working directory
; Ensures a consistent starting directory
SetWorkingDir %A_ScriptDir%

; sets title matching to search for "containing" instead of "exact"
SetTitleMatchMode, 2
return
;=======================Auto Execution Section End================================

; overview on all shorcuts: ctrl + alt + 0
^!0::
MsgBox,, Hotkeys, 
(
	- Explorer up a folder: middle mousekey
	- Always on top: ctrl + space
	- Suspend: WIN + ScrollLockKey
	- Toogle Discord Display without focus loss: F1
)
return

; Press middle mouse button to move up a folder in Explorer
#IfWinActive, ahk_class CabinetWClass
~MButton::Send !{Up} 
#IfWinActive
return

; Always on Top with "ctrl + space"
^SPACE:: Winset, Alwaysontop, , A 
Return

; Suspend AutoHotKey with "Win + scrollLockKey" (the scrollockkey is on the keyboard)
#ScrollLock::Suspend
return

; ======DEFAULT BEHAVIOR=======
; Default state of lock keys
SetNumlockState, AlwaysOn
SetScrollLockState, AlwaysOff
return

; Caps Lock acts as Shift
Capslock::Shift
return

F1::
	IfWinExist, Discord
		WinHide, Discord
	else
		WinShow, Discord
return
