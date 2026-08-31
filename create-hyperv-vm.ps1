# Requires: Hyper-V feature enabled, admin PowerShell, Win11 ISO downloaded
# Download the public Windows 11 multi-edition ISO (Home/Pro, no sign-in required):
# 1. Open https://www.microsoft.com/en-us/software-download/windows11
# 2. Under "Download Windows 11 Disk Image (ISO) for x64 devices", select the
#    multi-edition ISO and language, then download the generated x64 link.
# 3. Save or rename the ISO to the $ISOPath location below.

$VMName   = "Win11-Enterprise-VM"
$VMPath   = "D:\HyperV\$VMName"
$VHDPath  = "$VMPath\$VMName.vhdx"
$ISOPath  = "D:\iso\win11x64-enterprise-eval.iso"
$SwitchName = "Default Switch"   # or your own vSwitch name

New-Item -Path $VMPath -ItemType Directory -Force | Out-Null

New-VM -Name $VMName -MemoryStartupBytes 8GB -Generation 2 `
  -NewVHDPath $VHDPath -NewVHDSizeBytes 64GB -Path $VMPath `
  -SwitchName $SwitchName

Set-VMProcessor -VMName $VMName -Count 8
Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $true -MinimumBytes 8GB -MaximumBytes 16GB

Add-VMDvdDrive -VMName $VMName -Path $ISOPath
$dvd = Get-VMDvdDrive -VMName $VMName
Set-VMFirmware -VMName $VMName -EnableSecureBoot On -FirstBootDevice $dvd

# TPM required for Win11 — needs a Key Protector
Set-VMKeyProtector -VMName $VMName -NewLocalKeyProtector
Enable-VMTPM -VMName $VMName

Start-VM -Name $VMName
vmconnect.exe localhost $VMName
