#Requires AutoHotkey v2.0
#SingleInstance
#UseHook
ProcessSetPriority "High"
A_MenuMaskKey := "vkFF"

^+!r:: Reload
^+!e:: Edit
^+!d:: KeyHistory
#SuspendExempt
^+!s:: Suspend
#SuspendExempt False

global HomeDir := EnvGet("HomeDrive") EnvGet("HomePath")
global AppsDir := HomeDir "\scoop\apps"
global ShimsDir := HomeDir "\scoop\shims"
global PersistDir := HomeDir "\scoop\persist"
global ReleaseDuration := 200

; LWin rebound to F12 through registry to avoid window manager + start menu issues
SetNumLockState("AlwaysOn")
SetCapsLockState("AlwaysOff")
SetScrollLockState("AlwaysOff")

CapsLock::Ctrl
^[::Escape

F12 & Space::Numpad0 ; for launcher

; launch apps

#Include de-elevated-run.lib.ahk

Activate(criteria)
{
    ;WinWait criteria ; less reliable with glazewm

	while (WinExist(criteria) == false)
	{
		Sleep 200
	}

	WinActivate criteria
}

; AlacrittyRunString := ShimsDir '\alacritty.exe --working-directory ' HomeDir ' --config-file ' PersistDir '\alacritty\alacritty.toml'

; F12 & c::
; {
;     RunDeelevatedDefault AlacrittyRunString
;     Activate "Alacritty"
; }
;
; #HotIf GetKeyState("Shift", "P")
; F12 & c::
; {
;     Run AlacrittyRunString, '', 'Hide'
;     Activate "Alacritty"
; }
; #HotIf
;
; F12 & x::
; {
;     Run 'explorer.exe ' HomeDir
; }
;
; F12 & v::
; {
;     ;RunDeelevatedDefault AppsDir "\everything\current\Everything.exe"
;     Run AppsDir "\everything\current\Everything.exe"
;     Activate "ahk_exe everything.exe"
; }
;
; F12 & b::
; {
;     RunDeelevatedDefault AppsDir '\vivaldi\current\Application\vivaldi.exe'
;     Activate "ahk_exe vivaldi.exe"
; }
;
; F12 & \::
; {
;     RunDeelevatedDefault '"C:\Program Files\1Password\app\8\1Password.exe" --quick-access'
; }

; F12 & n::
; {
;     RunDeelevatedDefault '"' AppsDir '\neovide\current\neovide.exe" --wsl'
; }

; komorebi

; F12 & a::NumLock ; focus mode toggle
; F12 & s::NumpadMult ; binding mode send
; F12 & g::NumpadAdd ; reload config
; F12 & z::NumpadDiv ; tiling direction toggle
; F12 & y::NumpadSub ; exit wm

; F12 & o::Numpad1 ; resize width +10%
; F12 & y::Numpad3 ; resize width -10%
; F12 & u::Numpad7 ; resize height +10%
; F12 & i::Numpad9 ; resize height -10%

F12 & c::Run "komorebic close", , "Hide" ; close
F12 & f::Run "komorebic toggle-monocle", , "Hide" ; toggle maximized

F12 & h::Run "komorebic focus left", , "Hide" ; focus left
F12 & j::Run "komorebic focus down", , "Hide" ; focus down
F12 & k::Run "komorebic focus up", , "Hide" ; focus up
F12 & l::Run "komorebic focus right", , "Hide" ; focus right

F12 & q::Run "komorebic focus-workspace 0", , "Hide" ; focus workspace m0w0
F12 & w::Run "komorebic focus-workspace 1", , "Hide" ; focus workspace m0w1
F12 & e::Run "komorebic focus-workspace 2", , "Hide" ; focus workspace m0w2
F12 & r::Run "komorebic focus-workspace 3", , "Hide" ; focus workspace m0w3
F12 & t::Run "komorebic focus-workspace 4", , "Hide" ; focus workspace m0w4
F12 & 1::Run "komorebic focus-workspace 5", , "Hide" ; focus workspace m1w0
F12 & 2::Run "komorebic focus-workspace 6", , "Hide" ; focus workspace m1w1
F12 & 3::Run "komorebic focus-workspace 7", , "Hide" ; focus workspace m1w2
F12 & 4::Run "komorebic focus-workspace 8", , "Hide" ; focus workspace m1w3
F12 & 5::Run "komorebic focus-workspace 9", , "Hide" ; focus workspace m1w4

#HotIf GetKeyState("Shift", "P")
F12 & h::Run "komorebic move left", , "Hide" ; move left
F12 & j::Run "komorebic move down", , "Hide" ; move down
F12 & k::Run "komorebic move up", , "Hide" ; move up
F12 & l::Run "komorebic move right", , "Hide" ; move right

F12 & q::Run "komorebic send-to-workspace 0", , "Hide" ; focus workspace m0w0
F12 & w::Run "komorebic send-to-workspace 1", , "Hide" ; focus workspace m0w1
F12 & e::Run "komorebic send-to-workspace 2", , "Hide" ; focus workspace m0w2
F12 & r::Run "komorebic send-to-workspace 3", , "Hide" ; focus workspace m0w3
F12 & t::Run "komorebic send-to-workspace 4", , "Hide" ; focus workspace m0w4
F12 & 1::Run "komorebic send-to-workspace 5", , "Hide" ; focus workspace m1w0
F12 & 2::Run "komorebic send-to-workspace 6", , "Hide" ; focus workspace m1w1
F12 & 3::Run "komorebic send-to-workspace 7", , "Hide" ; focus workspace m1w2
F12 & 4::Run "komorebic send-to-workspace 8", , "Hide" ; focus workspace m1w3
F12 & 5::Run "komorebic send-to-workspace 9", , "Hide" ; focus workspace m1w4
#HotIf

; homerow navigation

; ~`; & h::Left
; ~`; & j::Down
; ~`; & k::Up
; ~`; & l::Right
; ~`; & m::PgUp
; ~`; & n::PgDn
; ~`; & u::Home
; ~`; & o::End
; ~`; & i::Enter
; ~`; & ,::BackSpace
; ~`; & .::Delete

; *;::
; {
; 	static pressed
; 	pressed := True
; 	SetTimer Expire() => pressed := false, -ReleaseDuration
; 	KeyWait ";"
;
; 	if (A_ThisHotkey = "*;" and pressed = True)
; 	{
; 		SetTimer Expire, 0
; 		SendInput "{Blind}{;}"
; 		Return
; 	}
;
; 	Return
; }
