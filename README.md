# PowershellLovesFalcox
FalcoX Configurator PowerShell Module</br>
</br>
</br>
Changelog:</br>
    * Added Autodetect COM-port</br>
    * Added Get-FalcoXHelp</br>
</br></br>
Changelog (for n00bs script):</br>
    * Added Preset tunes and export tunes</br>
    * Added Autodetect COM-port</br>
</br></br></br>

## Installation/Download

Download 
Open PowerShell.exe (start->run->type "powershell.exe"-> press "enter")</br>
Paste the commands below into Powershell and press "enter"</br>
You should now have two zip-files on your Desktop that you need to extract "FalcoXLovesPowershell.zip" and "FalcoXLovesPowerShell_for_n00bs"</br>

```Powershell
#Download FalcoXLovesPowerShell for n00bs
iwr -Uri https://github.com/tedelm/PowershellFalcox/blob/master/FalcoXLovesPowerShell_for_n00bs/FalcoXLovesPowershell_for_n00bs.zip?raw=true -OutFile "C:\Users\$($env:USERNAME)\desktop\FalcoXLovesPowerShell_for_n00bs.zip"
#Unpack FalcoXLovesPowerShell for n00bs
Expand-Archive -LiteralPath "C:\Users\$($env:USERNAME)\desktop\FalcoXLovesPowerShell_for_n00bs.zip" -DestinationPath "C:\Users\$($env:USERNAME)\desktop\FalcoXLovesPowerShell_for_n00bs"
#Start FalcoXLovesPowerShell for n00bs
cd "C:\Users\$($env:USERNAME)\desktop\FalcoXLovesPowerShell_for_n00bs"
start '.\Start FalcoXLovesPowerShell.cmd'
#Download full
iwr -Uri https://github.com/tedelm/PowershellFalcox/blob/master/FalcoXLovesPowershell.zip?raw=true -OutFile "C:\Users\$($env:USERNAME)\desktop\FalcoXLovesPowershell.zip"
#Unpack full
Expand-Archive -LiteralPath "C:\Users\$($env:USERNAME)\desktop\FalcoXLovesPowershell.zip" -DestinationPath "C:\Users\$($env:USERNAME)\desktop\FalcoXLovesPowerShell"

```
</br></br>
Or use http-links:</br>
 * <a href='https://github.com/tedelm/PowershellFalcox/blob/master/FalcoXLovesPowershell.zip?raw=true' target='_BLANK'>FalcoXLovesPowerShell.zip</a></br>
 * <a href='https://github.com/tedelm/PowershellFalcox/blob/master/FalcoXLovesPowerShell_for_n00bs/FalcoXLovesPowershell_for_n00bs.zip?raw=true' target='_BLANK'>FalcoXLovesPowerShell_for_n00bs.zip</a></br>
 </br>
 Or use LTS version (Does not update that often, not really a LTS :D ):
  * <a href='https://github.com/tedelm/PowershellFalcox/releases' target='_BLANK'>FalcoXLovesPowerShell Releases</a></br>

 </br>



## PowerShellLovesFalcoX for n00bs
Download FalcoXLovesPowerShell_for_n00bs.zip and extract the files</br>
Connect your FlightController</br>
Double click on "Start FalcoXLovesPowerShell.cmd"</br>
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/n00bs001.PNG'></br>
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/n00bs002.PNG'></br>
</br>
Presets and extract only PIDS,Filters and rates from your dump/backup
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/n00bs003.PNG'></br>
</br>
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/n00bs004.PNG'></br>
</br>
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/n00bs005.PNG'></br>
</br>
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/n00bs006.PNG'></br>
</br>
HTML Report:</br>
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/exportHtml_2.PNG'>
</br></br>

## Help! - FalcoXLovesPowershell help
Import-Module .\FalcoXLovesPowershell.ps1</br>
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/GetFalcoXHelp_01.PNG'></br>

```Powershell
#List all available functions
Get-FalcoXHelp

#Show examples
Get-FalcoXHelp -Function "setup-falcox"

```

## Optional - Make Powershell load script on startup
Open Powershell and write "notepad.exe $PROFILE", press [ENTER]</br>
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/powershellprofile_02.PNG'></br>
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/powershellprofile_03.PNG'></br>
Copy and paste all the lines below, remember to change "-FalcoXLovesPowershellFolder" to your folder. Save and restart Powershell.</br>
Copy this-></br>
```Powershell
##### Load FalcoX in powershell profile
function FalcoXLoad(){
    param (
        [parameter(Mandatory=$false)][string]$FalcoXLovesPowershellFolder = "C:\Users\teel\Google Drive\Drone\FalcoXLovesPowershell",
        [parameter(Mandatory=$false)][string]$FalcoXLovesPowershellPS1 = "FalcoXLovesPowershell.ps1",
        [parameter(Mandatory=$false)][string]$FalcoXLovesPowershellPSM1 = "FalcoXLovesPowershell.psm1"
    )
    
    $script:FalcoXLovesPowershellFolder = $FalcoXLovesPowershellFolder
    $script:FalcoXLovesPowershellPS1 = $FalcoXLovesPowershellPS1

    #Join path
    $FalcoXLovesPowershellFullPath = join-path "$($FalcoXLovesPowershellFolder)" "$($FalcoXLovesPowershellPS1)"
    $FalcoXLovesPowershellFullPathPSM = join-path "$($FalcoXLovesPowershellFolder)" "$($FalcoXLovesPowershellPSM1)"
    #Change directory to allow modules to be imported
    Set-Location "$($FalcoXLovesPowershellFolder)"
    #Import modules
    Import-Module "$($FalcoXLovesPowershellFullPathPSM)"
    #Set variable for FalcoXPath, to be used seperatly
    $script:FalcoXPath = "$($FalcoXLovesPowershellFolder)"
    #Go back to start directory
    Set-Location ~
}

#Load FalcoX script and create variables for path $FalcoXPath and loads all functions
FalcoXLoad -FalcoXLovesPowershellFolder "C:\Users\teel\Google Drive\Drone\FalcoXLovesPowershell"
```
<img src='https://github.com/tedelm/PowershellFalcox/blob/master/img/powershellprofile_01.PNG'></br>



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