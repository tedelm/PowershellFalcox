# PowershellLovesFalcox
Offline configuration editor for powershell

<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/GetOnline.PNG'>
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/GetLocal.PNG'>

# Usage
1. Save/Backup Config from FalcoX Companion to same folder as "FalcoXLovesPowerShell.ps1"
2. Open Powershell and navigate to your "FalcoXLovesPowershell" folder </br> e.g (without quotes) "cd C:\Users\\$env:username\Downloads\"
3. In Powershell:</br>
. .\FalcoXLovesPowershell.ps1</br>
Get-FalcoXConfigLocal -InputFile "< path to your falcoX backup file >.txt"  -PIDs -Filters -Rates -TPA</br>

# Online Usage (USB)
Get-FalcoXConfig -comPort COMx -Pilotname -VtxChannel

# To Do list...
* Create Set-FalcoX functionality - Working on it!
* Create Serial interface (Possible?) - YES! Working on it!
