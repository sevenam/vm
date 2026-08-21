# Requires: Hyper-V feature enabled, admin PowerShell

param(
    [string]$SnapshotName = "Snapshot-$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss')"
)

$VMName = "Win11-Enterprise-VM"

$vm = Get-VM -Name $VMName -ErrorAction SilentlyContinue
if (-not $vm) {
    Write-Host "VM '$VMName' does not exist."
    return
}

Checkpoint-VM -Name $VMName -SnapshotName $SnapshotName

Write-Host "Snapshot '$SnapshotName' created for VM '$VMName'."
