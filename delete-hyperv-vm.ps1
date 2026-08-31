# Requires: Hyper-V feature enabled, admin PowerShell

param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$Name = "Win11-VM"
)

$VMPath = "D:\HyperV\$Name"

$vm = Get-VM -Name $Name -ErrorAction SilentlyContinue
if (-not $vm) {
    Write-Host "VM '$Name' does not exist. Nothing to do."
    return
}

if ($vm.State -ne 'Off') {
    Stop-VM -Name $Name -TurnOff -Force
}

Remove-VM -Name $Name -Force

if (Test-Path $VMPath) {
    Remove-Item -Path $VMPath -Recurse -Force
}

Write-Host "VM '$Name' and its files have been removed."
