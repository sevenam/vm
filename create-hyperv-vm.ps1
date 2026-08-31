# Requires: Hyper-V feature enabled, admin PowerShell, Win11 ISO downloaded
# Download the public Windows 11 multi-edition ISO (Home/Pro, no sign-in required):
# 1. Open https://www.microsoft.com/en-us/software-download/windows11
# 2. Under "Download Windows 11 Disk Image (ISO) for x64 devices", select the
#    multi-edition ISO and language, then download the generated x64 link.
# 3. Save or rename the ISO to the $ISOPath location below.

param(
  [Parameter()]
  [ValidateNotNullOrEmpty()]
  [string]$Name = "Win11-VM"
)

$VMPath   = "D:\HyperV\$Name"
$VHDPath  = "$VMPath\$Name.vhdx"
$ISOPath  = "D:\iso\win11x64-enterprise-eval.iso"
$SwitchName = "Default Switch"   # or your own vSwitch name

New-Item -Path $VMPath -ItemType Directory -Force | Out-Null

New-VM -Name $Name -MemoryStartupBytes 8GB -Generation 2 `
  -NewVHDPath $VHDPath -NewVHDSizeBytes 64GB -Path $VMPath `
  -SwitchName $SwitchName

Set-VMProcessor -VMName $Name -Count 8
Set-VMMemory -VMName $Name -DynamicMemoryEnabled $true -MinimumBytes 8GB -MaximumBytes 16GB

Add-VMDvdDrive -VMName $Name -Path $ISOPath
$dvd = Get-VMDvdDrive -VMName $Name
Set-VMFirmware -VMName $Name -EnableSecureBoot On -FirstBootDevice $dvd

# TPM required for Win11 — needs a Key Protector
Set-VMKeyProtector -VMName $Name -NewLocalKeyProtector
Enable-VMTPM -VMName $Name

Start-VM -Name $Name
vmconnect.exe localhost $Name
