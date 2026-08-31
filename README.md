# Hyper-V VM Scripts

PowerShell scripts for creating and managing a local Windows 11 Hyper-V VM.

## Create a VM

1. Enable Hyper-V and open PowerShell as Administrator.
2. Download the ISO from the
   [Windows 11 download page](https://www.microsoft.com/en-us/software-download/windows11).
3. Save or rename the ISO as `D:\iso\win11x64-enterprise-eval.iso`.
4. From this directory, create the default `Win11-VM`:

```powershell
.\create-hyperv-vm.ps1
```

To use a different VM name, pass `-Name`:

```powershell
.\create-hyperv-vm.ps1 -Name "My-Windows-VM"
```

The VM files are stored under `D:\HyperV\<Name>`.

## Delete a VM

Open PowerShell as Administrator. To delete the default `Win11-VM`, run:

```powershell
.\delete-hyperv-vm.ps1
```

To delete a VM with a different name, pass `-Name`:

```powershell
.\delete-hyperv-vm.ps1 -Name "My-Windows-VM"
```

The script force-stops the VM if it is running, then removes the VM and its
files under `D:\HyperV\<Name>`.
