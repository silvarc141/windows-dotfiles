Start-Process -FilePath "$env:USERPROFILE\.config\autohotkey\init.ahk"

$ScoopAppsPath = "$env:USERPROFILE\scoop\apps"
Start-Process -FilePath "$ScoopAppsPath\glazewm\current\GlazeWM.exe"
Start-Process -FilePath "$ScoopAppsPath\everything\current\Everything.exe" -ArgumentList "-startup"
