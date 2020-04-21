# PowershellLovesFalcox
FalcoX Configurator PowerShell Module

## Installation/Download

Open PowerShell.exe (start->run->type "powershell.exe"-> press "enter")</br>
Paste the commands below into Powershell and press "enter"</br>
You should now have two zip-files on your Desktop that you need to extract "FalcoXLovesPowershell.zip" and "FalcoXLovesPowerShell_for_n00bs"</br>

```Powershell
iwr -Uri https://github.com/tedelm/PowershellFalcox/blob/master/FalcoXLovesPowerShell_for_n00bs/FalcoXLovesPowershell_for_n00bs.zip?raw=true -OutFile C:\Users\$($env:USERNAME)\desktop\FalcoXLovesPowershell.zip
iwr -Uri https://github.com/tedelm/PowershellFalcox/blob/master/FalcoXLovesPowershell.zip?raw=true -OutFile C:\Users\$($env:USERNAME)\desktop\FalcoXLovesPowershell.zip
```


## PowerShellLovesFalcoX for n00bs
Download FalcoXLovesPowerShell_for_n00bs.zip and extract the files</br>
Connect your FlightController</br>
Double click on "Start FalcoXLovesPowerShell.cmd"</br>
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/n00bs001.PNG'></br>
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/n00bs002.PNG'></br>
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/exportHtml_2.PNG'>
</br></br>

## Online Usage (USB): "Setup" commands
1. Open Powershell and navigate to your "FalcoXLovesPowershell" folder </br> e.g (without quotes) "cd C:\Users\\$env:username\Downloads\"
2. In Powershell:</br>
```Powershell
Import-Module .\FalcoXLovesPowershell.ps1
#Reset all config
Setup-FalcoX -comPort com10 -ResetConfig
#Reset Wizard
Setup-FalcoX -comPort com10 -ResetWizard
#Set Wizard complete
Setup-FalcoX -comPort com10 -WizardCompleted
#Enter DFU/STM32 Bootloader mode
Setup-FalcoX -comPort com10 -EnterDFU
#Setting UARTS and Protocols 
#Setting CRSF on UART1
Setup-FalcoX -comPort com10 -SetUART 1 -SetUARTProtocol 2
```
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/Setup-FalcoX_01.PNG'>


## Online Usage (USB): "Get" commands
1. Open Powershell and navigate to your "FalcoXLovesPowershell" folder </br> e.g (without quotes) "cd C:\Users\\$env:username\Downloads\"
2. In Powershell:</br>
```Powershell
Import-Module .\FalcoXLovesPowershell.ps1
Get-FalcoXConfig -comPort COM7 `
 -VtxChannel `
 -PilotName `
 -FWVersion `
 -Filters `
 -PIDs `
 -TPA `
 -Rates

 #Or displaying all
 Get-FalcoXConfig -comPort COM7 -All

 #Or using a powershell table
 Get-FalcoXConfig -comPort COM7 -AllTable | format-list
 Get-FalcoXConfig -comPort COM7 -AllTable | format-table
 Get-FalcoXConfig -comPort COM7 -AllTable | Select "roll_*","pitch_*","yaw_*"

```
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/GetOnline.PNG'>

## Online Usage (USB): "Set" commands</br>
Available commands/switches (use one or more):
```Powershell
Import-Module .\FalcoXLovesPowershell.ps1

Set-FalcoXConfig -comPort com7 `
-PilotName "DolphinFeeder2000" `
-VtxChannel R7 `
-LedColor 255,0,0 `
-PIDroll 65,45,175 `
-PIDpitch 64,45,175 `
-PIDyaw 58,45,0 `
-Filter1 "Frequency" `
-Filter2 "Dynamic" `
-Filter1Freq 240 `
-Filter2Freq 105 `
-DFilter1 "BiQuad" `
-DFilter2 "BiQuad" `
-DFilter1Freq 200 `
-DFilter2Freq 200

```
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/SetOnlinePilotname.PNG'>


## Online Usage (USB): "Backup" commands</br>
```Powershell
Import-Module .\FalcoXLovesPowershell.ps1
Get-FalcoXConfig -comPort COM7 -Dump -Outputfile .\MyFalcoXBackup.txt

```
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/GetBackup.PNG'>

## Online Usage (USB): "Restore" commands</br>
```Powershell
Import-Module .\FalcoXLovesPowershell.ps1
Set-FalcoXConfig -comPort COM7 -Restore -RestoreFilePath .\MyFalcoXBackup.txt


```
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/SetRestore.PNG'>

## Online Usage (USB): "HTML export" commands</br>
A shout out to @PaPaYoU for the original layout.

```Powershell
Import-Module .\FalcoXLovesPowershell.ps1
Export-FalcoXReportHtml -comPort com7


```
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/ExportHTML.PNG'>
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/exportHtml_2.PNG'>


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
- [x]  Create Serial interface (Possible?) - YES! Working!
- [x]  Create "Get-FalcoXConfigLocal" functionality - Done!
- [ ]  Create "Set-FalcoXConfigLocal" functionality - Working on it!
- [ ]  Create Set-FalcoXConfig functionality - Working on it!
- [x]  Create Get-FalcoXConfig functionality - Working on it!
- [ ]  Add Esc protocoll lookup - Working on it!
- [ ]  VTX channel mapping, not verified - Working on it!
- [x]  Cli: Version - Done!
- [ ]  Speed up restore cmdlet - Working on it!

## Problems that may occur
* Insufficient rights/Problem loading module/script
```Powershell
Import-Module : File <\FalcoXLovesPowershell.ps1> cannot use running scripts is disabled on this system.
```
To solve this, open powershell.exe as Administrator and run
```Powershell
Set-executionpolicy unrestricted
```
To revert settings again use:
```Powershell
Set-executionpolicy remotesigned
```

## Install Powershell
Powershell is installed by default on any later version of Windows</br>

Install steps on MAC</br>
```Powershell
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew cask install powershell

```
Install steps for Linux</br>
https://www.rootusers.com/how-to-install-powershell-on-linux/


## Support
* This is a third-party tool, use at own risk!
* The PowerShell module is only compatible with FalcoX