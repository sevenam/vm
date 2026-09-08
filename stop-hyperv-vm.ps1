# Requires: Hyper-V feature enabled, admin PowerShell

param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$Name = "Win11-VM"
)

$vm = Get-VM -Name $Name -ErrorAction SilentlyContinue
if (-not $vm) {
    Write-Error "VM '$Name' does not exist."
    exit 1
}

if ($vm.State -ne 'Off') {
    Stop-VM -Name $Name -TurnOff -Force
}

Write-Host "VM '$Name' is stopped."
