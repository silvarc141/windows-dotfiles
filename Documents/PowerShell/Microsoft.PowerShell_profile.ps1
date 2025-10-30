Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

Get-ChildItem ~/.config/ps-scripts/common | Foreach-Object {. $_}
$env:PATH += ";C:\Program Files\Git\bin"
