Get-ChildItem "$HOME\.config\ps-scripts\common" | ForEach-Object { . $_.FullName }

Start-Process -FilePath "$env:USERPROFILE\.config\autohotkey\de-elevated-run-init.ahk"
# Start-Job { Start-Process -FilePath "$env:PROGRAMFILES\1Password\app\8\1Password.exe" -ArgumentList "--silent" }

$ScoopAppsPath = "$env:USERPROFILE\scoop\apps"
Start-Process -FilePath "$ScoopAppsPath\sharex\current\ShareX.exe" -ArgumentList "-silent"
Start-Process -FilePath "$ScoopAppsPath\keypirinha\current\keypirinha.exe"

Hide-Files "_*" $HOME
Hide-Files ".*" $HOME
