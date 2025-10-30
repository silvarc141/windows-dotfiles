ReceiveAndExecute(wParam, lParam, msg, hwnd)
{
    output := Receive_WM_COPYDATA(wParam, lParam, msg, hwnd)

    if (output.Result = true)
    {
        Run output.Value, '', 'Hide'
    }

    return output.Result
}

Receive_WM_COPYDATA(wParam, lParam, msg, hwnd)
{
    stringAddress := NumGet(lParam, 2 * A_PtrSize, "Ptr")  ; Retrieves the CopyDataStruct's lpData member.
    copyOfData := StrGet(stringAddress)  ; Copy the string out of the structure.
    output := {}
    output.Result := true
    output.Value := copyOfData
    return output
}

RunDeelevated(command, launcherScriptName)
{
    TargetScriptTitle := launcherScriptName " ahk_class AutoHotkey"

	result := Send_WM_COPYDATA(command, TargetScriptTitle)

	if result = ""
	{
		MsgBox "SendMessage failed or timed out. Does the following WinTitle exist?:`n" TargetScriptTitle
	}
	else if (result = 0)
	{
		MsgBox "Message sent but the target window responded with 0, which may mean it ignored it."
	}

	return result
}

RunDeelevatedDefault(command) => RunDeelevated(command, "de-elevated-run-init.ahk")

ActivateWindow(criteria)
{
	WinWait(criteria)
    WinActivate criteria
}

RunDeelevatedDefaultNoWait(command)
{
	Callback()
	{
		Send_WM_COPYDATA(command, "de-elevated-run-init.ahk ahk_class AutoHotkey")
	}

	SetTimer(Callback, -1000)
}

Send_WM_COPYDATA(StringToSend, TargetScriptTitle)
; This function sends the specified string to the specified window and returns the reply.
; The reply is 1 if the target window processed the message, or 0 if it ignored it.
{
	CopyDataStruct := Buffer(3 * A_PtrSize)  ; Set up the structure's memory area.
	; First set the structure's cbData member to the size of the string, including its zero terminator:
	SizeInBytes := (StrLen(StringToSend) + 1) * 2
	NumPut("Ptr", SizeInBytes  ; OS requires that this be done.
		, "Ptr", StrPtr(StringToSend)  ; Set lpData to point to the string itself.
		, CopyDataStruct, A_PtrSize)
	Prev_DetectHiddenWindows := A_DetectHiddenWindows
	Prev_TitleMatchMode := A_TitleMatchMode
	DetectHiddenWindows True
	SetTitleMatchMode 2
	TimeOutTime := 4000  ; Optional. Milliseconds to wait for response from receiver.ahk. Default is 5000
	; Must use SendMessage not PostMessage.
	RetValue := SendMessage(0x004A, 0, CopyDataStruct, , TargetScriptTitle, , , , TimeOutTime) ; 0x004A is WM_COPYDATA.

	DetectHiddenWindows Prev_DetectHiddenWindows  ; Restore original setting for the caller.
	SetTitleMatchMode Prev_TitleMatchMode         ; Same.
	return RetValue  ; Return SendMessage's reply back to our caller.
}
