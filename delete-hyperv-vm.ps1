# Requires: Hyper-V feature enabled, admin PowerShell

$VMName = "Win11-Enterprise-VM"
$VMPath = "D:\HyperV\$VMName"

$vm = Get-VM -Name $VMName -ErrorAction SilentlyContinue
if (-not $vm) {
    Write-Host "VM '$VMName' does not exist. Nothing to do."
    return
}

if ($vm.State -ne 'Off') {
    Stop-VM -Name $VMName -TurnOff -Force
}

Remove-VM -Name $VMName -Force

if (Test-Path $VMPath) {
    Remove-Item -Path $VMPath -Recurse -Force
}

Write-Host "VM '$VMName' and its files have been removed."
