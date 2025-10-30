function Switch-NetworkAdapter {
    param([string]$AdapterNameMatch = "*Ethernet*")

    $adapters = Get-NetAdapter | Where-Object { $_.Name -like $Match }

    foreach ($adapter in $adapters) {
        if ($adapter.Status -ne 'Up') {
            Enable-NetAdapter -Name $adapter.Name -Confirm:$false
        }
        else {
            Disable-NetAdapter -Name $adapter.Name -Confirm:$false
        }
    }
}
