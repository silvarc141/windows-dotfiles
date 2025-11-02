Start-Process -FilePath "$env:USERPROFILE\.config\autohotkey\init.ahk"
$ScoopAppsPath = "$env:USERPROFILE\scoop\apps"
Start-Process -FilePath "$ScoopAppsPath\everything\current\Everything.exe" -ArgumentList "-startup"
Start-Process -FilePath "$ScoopAppsPath\komorebi\current\komorebi.exe"
