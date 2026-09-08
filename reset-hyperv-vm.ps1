# Requires: Hyper-V feature enabled, admin PowerShell

param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$VMName = "Win11-Enterprise-VM",

    [Parameter()]
    [string]$SnapshotName
)

$vm = Get-VM -Name $VMName -ErrorAction SilentlyContinue
if (-not $vm) {
    Write-Error "VM '$VMName' does not exist."
    exit 1
}

$snapshots = @(Get-VMSnapshot -VMName $VMName)
if ($snapshots.Count -eq 0) {
    Write-Error "VM '$VMName' has no snapshots to restore."
    exit 1
}

if ([string]::IsNullOrWhiteSpace($SnapshotName)) {
    $snapshot = $snapshots |
        Sort-Object -Property CreationTime -Descending |
        Select-Object -First 1
}
else {
    $snapshot = $snapshots |
        Where-Object { $_.Name -eq $SnapshotName } |
        Select-Object -First 1

    if (-not $snapshot) {
        Write-Error "Snapshot '$SnapshotName' was not found for VM '$VMName'."
        exit 1
    }
}

if ($vm.State -ne 'Off') {
    Stop-VM -Name $VMName -TurnOff -Force
}

Restore-VMSnapshot -VMName $VMName -Name $snapshot.Name -Confirm:$false

Write-Host "VM '$VMName' was restored to snapshot '$($snapshot.Name)'."
