# PowershellLovesFalcox
FalcoX Configurator PowerShell Module

<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/GetOnline.PNG'>
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/GetLocal.PNG'>


## Online Usage (USB)
1. Open Powershell and navigate to your "FalcoXLovesPowershell" folder </br> e.g (without quotes) "cd C:\Users\\$env:username\Downloads\"
2. In Powershell:</br>
Import-Module .\FalcoXLovesPowershell.ps1 </br>
Get-FalcoXConfig -comPort COMx -Pilotname -VtxChannel

## Backup </br>
<
Import-Module .\FalcoXLovesPowershell.ps1 </br>
Get-FalcoXConfig -comPort COMx -Dump -Outputfile .\MyFalcoXBackup.txt
>
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/GetBackup.PNG'>

## Offline Usage
1. Save a backup of config by using "Get-FalcoXConfig -comPort COMx -Dump -Outputfile .\MyFalcoXBackup.txt" to same folder as "FalcoXLovesPowerShell.ps1"
2. Open Powershell and navigate to your "FalcoXLovesPowershell" folder </br> e.g (without quotes) "cd C:\Users\\$env:username\Downloads\"
3. In Powershell:</br>
Import-Module .\FalcoXLovesPowershell.ps1 </br>
Get-FalcoXConfigLocal -InputFile "< path to your falcoX backup file >.txt"  -PIDs -Filters -Rates -TPA</br>



## To Do list...
- [x]  Create Serial interface (Possible?) - YES! Working on it!
- [x]  Create "Get-FalcoXConfigLocal" functionality - Working on it!
- [ ]  Create "Set-FalcoXConfigLocal" functionality - Working on it!
- [ ]  Create Set-FalcoX functionality - Working on it!
