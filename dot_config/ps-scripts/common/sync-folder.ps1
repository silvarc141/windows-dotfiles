function Sync-Folder {

    param (
        [string]$LocalFolderPath="$home/sync",
        [string]$RemoteFolderPath="gdrive:sync",
        [string]$FilterFileName=".rclone_filter.txt"
    )

    $filterFilePath = "$LocalFolderPath/$FilterFileName"

    if(-not (Test-Path $LocalFolderPath -PathType Container)) {New-Item -ItemType Directory -Force $LocalFolderPath}

    $TitleMsg = "Syncing to remote path: `"$RemoteFolderPath`""

    # Check connection
    $DescriptionMsg = "Checking connection for local path `"$LocalFolderPath`""
    Write-Output "$TitleMsg`n$DescriptionMsg`n"
    rclone tree "gdrive:sync" --level 1 -d | out-null

    if($?)
    {
        $DescriptionMsg = "Connection exists. Syncing local path `"$LocalFolderPath`""
        Write-Output "$DescriptionMsg`n"

        $BisyncResult = rclone bisync $LocalFolderPath $RemoteFolderPath `
        --filters-file $filterFilePath `
        --verbose `
        --resilient `
        --recover `
        --max-lock 2m `
        --drive-acknowledge-abuse `
        --check-access `
        --check-filename ".rclone_check_access.txt" `
        --create-empty-src-dirs `
        --track-renames `
        --max-delete 80
    }

    # Critically aborted
    if($BisyncResult -eq 2)
    {
        $DescriptionMsg = "Syncing failed for local path `"$LocalFolderPath`" with result `"$BisyncResult`".`nResyncing."
        Write-Output "$DescriptionMsg`n"

        # Sync failed notification
        Add-Type -AssemblyName System.Windows.Forms
        $global:balmsg = New-Object System.Windows.Forms.NotifyIcon
        $path = (Get-Process -id $pid).Path
        $balmsg.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
        $balmsg.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning
        $balmsg.BalloonTipTitle = $TitleMsg
        $balmsg.BalloonTipText = $DescriptionMsg
        $balmsg.Visible = $true
        $balmsg.ShowBalloonTip(20000)

        # Resync
        rclone bisync $LocalFolderPath $RemoteFolderPath --filters-file $filterFilePath --verbose --drive-acknowledge-abuse --resync

        if(!$?)
        {
            $DescriptionMsg = "Resyncing failed for local path `"$LocalFolderPath`"`" even though connection was okay."
            Write-Output "$DescriptionMsg`n"

            # Resync failed notification
            $balmsg.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Error
            $balmsg.BalloonTipTitle = $TitleMsg
            $balmsg.BalloonTipText = $DescriptionMsg
            $balmsg.Visible = $true
            $balmsg.ShowBalloonTip(20000)
        }
    }
}
