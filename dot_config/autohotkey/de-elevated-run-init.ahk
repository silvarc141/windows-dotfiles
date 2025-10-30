; Start this independently, non-elevated
#Include de-elevated-run.lib.ahk
OnMessage 0x004A, ReceiveAndExecute  ; 0x004A is WM_COPYDATA
Persistent