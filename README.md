# PowershellLovesFalcox
#FalcoX Configurator PowerShell Module

## Online Usage (USB): "Get" commands
1. Open Powershell and navigate to your "FalcoXLovesPowershell" folder </br> e.g (without quotes) "cd C:\Users\\$env:username\Downloads\"
2. In Powershell:</br>
```Powershell
Import-Module .\FalcoXLovesPowershell.ps1
Get-FalcoXConfig -comPort COM7 -Pilotname -VtxChannel
```
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/GetOnline.PNG'>

## Online Usage (USB): "Set" commands</br>
```Powershell
```
## Online Usage (USB): "Backup" commands</br>
```Powershell
Import-Module .\FalcoXLovesPowershell.ps1
Get-FalcoXConfig -comPort COM7 -Dump -Outputfile .\MyFalcoXBackup.txt
```
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/GetBackup.PNG'>

## Offline Usage: 
1. Save a backup of config by using "Get-FalcoXConfig -comPort COMx -Dump -Outputfile .\MyFalcoXBackup.txt" to same folder as "FalcoXLovesPowerShell.ps1"
2. Open Powershell and navigate to your "FalcoXLovesPowershell" folder </br> e.g (without quotes) "cd C:\Users\\$env:username\Downloads\"
3. In Powershell:</br>

```Powershell
Import-Module .\FalcoXLovesPowershell.ps1
Get-FalcoXConfigLocal -InputFile "< path to your falcoX backup file >.txt"  -PIDs -Filters -Rates -TPA
```
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/GetLocal.PNG'>

## To Do list...
- [x]  Create Serial interface (Possible?) - YES! Working on it!
- [x]  Create "Get-FalcoXConfigLocal" functionality - Working on it!
- [ ]  Create "Set-FalcoXConfigLocal" functionality - Working on it!
- [ ]  Create Set-FalcoX functionality - Working on it!
- [ ]  VTX channel mapping, not verified - Working on it!


## Support
* This is a third-party tool, use at own risk!
* The PowerShell module is only compatible with FalcoX