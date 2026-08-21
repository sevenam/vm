# Requires: Hyper-V feature enabled, admin PowerShell, Win11 ISO downloaded

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
