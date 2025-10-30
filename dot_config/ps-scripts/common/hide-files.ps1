function Hide-Files {
    param([string]$Pattern = ".*", [string]$FolderPath = ".")
    $dotItems = Get-ChildItem -Path $FolderPath -Filter $Pattern -Force

    foreach ($item in $dotItems) {
        if (-not ($item.Attributes -band [System.IO.FileAttributes]::Hidden)) {
            $item.Attributes = $item.Attributes -bor [System.IO.FileAttributes]::Hidden
            Write-Host "Hiding $($item.FullName)"
        }
    }
}
