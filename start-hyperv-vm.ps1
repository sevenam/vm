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

if ($vm.State -eq 'Off') {
    Start-VM -Name $Name | Out-Null
}

vmconnect.exe localhost $Name
