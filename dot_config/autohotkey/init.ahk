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

; LWin rebound to F12 through registry to avoid glazewm + start menu issues
SetNumLockState("AlwaysOn")
SetCapsLockState("AlwaysOff")
SetScrollLockState("AlwaysOff")

CapsLock::Ctrl
^[::Escape

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

AlacrittyRunString := ShimsDir '\alacritty.exe --working-directory ' HomeDir ' --config-file ' PersistDir '\alacritty\alacritty.toml'

F12 & c::
{
    RunDeelevatedDefault AlacrittyRunString
    Activate "Alacritty"
}

#HotIf GetKeyState("Shift", "P")
F12 & c::
{
    Run AlacrittyRunString, '', 'Hide'
    Activate "Alacritty"
}
#HotIf

F12 & x::
{
    Run 'explorer.exe ' HomeDir
}

F12 & v::
{
    ;RunDeelevatedDefault AppsDir "\everything\current\Everything.exe"
    Run AppsDir "\everything\current\Everything.exe"
    Activate "ahk_exe everything.exe"
}

F12 & b::
{
    RunDeelevatedDefault AppsDir '\vivaldi\current\Application\vivaldi.exe'
    Activate "ahk_exe vivaldi.exe"
}

F12 & \::
{
    RunDeelevatedDefault '"C:\Program Files\1Password\app\8\1Password.exe" --quick-access'
}

F12 & n::
{
    RunDeelevatedDefault '"' AppsDir '\neovide\current\neovide.exe" --wsl'
    ;RunDeelevatedDefault AppsDir '\vivaldi\current\Application\vivaldi.exe'
}

F12 & Space::Numpad0

; glazewm

F12 & a::NumLock ; focus mode toggle
F12 & s::NumpadMult ; binding mode send
F12 & d::Numpad5 ; close
F12 & f::F24 ; toggle maximized
F12 & g::NumpadAdd ; reload config
F12 & z::NumpadDiv ; tiling direction toggle
F12 & y::NumpadSub ; exit wm

F12 & o::Numpad1 ; resize width +10%
F12 & y::Numpad3 ; resize width -10%
F12 & u::Numpad7 ; resize height +10%
F12 & i::Numpad9 ; resize height -10%

F12 & h::Numpad4 ; focus left
F12 & j::Numpad2 ; focus down
F12 & k::Numpad8 ; focus up
F12 & l::Numpad6 ; focus right

F12 & 1::F13 ; focus workspace m1w0
F12 & 2::F14 ; focus workspace m1w1
F12 & 3::F15 ; focus workspace m1w2
F12 & 4::F16 ; focus workspace m1w3
F12 & 5::F17 ; focus workspace m1w4

F12 & q::F18 ; focus workspace m0w0
F12 & w::F19 ; focus workspace m0w1
F12 & e::F20 ; focus workspace m0w2
F12 & r::F21 ; focus workspace m0w3
F12 & t::NumpadDot ; focus workspace m0w4

F12 & ]::F22 ; focus workspace next
F12 & [::F23 ; focus workspace prev

; homerow navigation

~`; & h::Left
~`; & j::Down
~`; & k::Up
~`; & l::Right
~`; & m::PgUp
~`; & n::PgDn
~`; & u::Home
~`; & o::End
~`; & i::Enter
~`; & ,::BackSpace
~`; & .::Delete

*;::
{
	static pressed
	pressed := True
	SetTimer Expire() => pressed := false, -ReleaseDuration
	KeyWait ";"

	if (A_ThisHotkey = "*;" and pressed = True)
	{
		SetTimer Expire, 0
		SendInput "{Blind}{;}"
		Return
	}

	Return
}
