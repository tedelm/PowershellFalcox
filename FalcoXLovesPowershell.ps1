<#
.SYNOPSIS
Use powershell to configure FL1 FalcoX

.DESCRIPTION
Comming soon...

.NOTES
Author
MRTEEL
Created: 2020-01-10
Edited: 
2020-01-12: Added function variables
2020-01-13: Added D-term percentage
2020-01-14: Added ComPort module for read/write to comport. Added support for simmode and whisper
2020-01-15: Added support for COM-port communication
2020-01-16: Added vtx channel mapping

.EXAMPLE
#### Read backup file
Import-Module .\FalcoXLovesPowershell.ps1
Get-FalcoXConfigLocal -InputFile ".\miniSquad_4inch_4s_falcoX_Alpha_v0.10.txt" -pids -filters -rates -tpa -VtxChannel

.EXAMPLE
#### Read configuration from flightcontroller
Get-FalcoXConfig -comPort COM7 -VtxChannel -PilotName -Filters -PIDs -TPA -Rates
Get-FalcoXConfig -comPort COM7 -Dump -Outputfile "Mybackup.txt"

.EXAMPLE
#### Set configuration flightcontroller
Set-FalcoXConfig -comPort com7 -PilotName "DolphinFeeder2000" -VtxChannel R7 -LedColor 255,0,0 -PIDroll 65,45,175 -PIDpitch 64,45,175 -PIDyaw 58,45,0 -Filter1Freq 240 -Filter2Freq 105 -DFilter1Freq 200 -DFilter2Freq 200 -Filter1 Frequency -Filter2 Dynamic -DFilter1 BiQuad -DFilter2 BiQuad

.EXAMPLE
#### Restore configuration flightcontroller
Set-FalcoXConfig -comPort COM7 -Restore -RestoreFilePath .\MyFalcoXBackup.txt

.EXAMPLE
#### Restore configuration flightcontroller
Set-FalcoXConfig -comPort COM7 -RestoreDump -RestoreFilePath .\MyFalcoXBackup.txt


.LINK
https://github.com/tedelm/PowershellFalcox

#>

#Import Modules
Import-Module '.\comPort.psm1' #Module to read/write to comport
Import-Module '.\vtxchannelmap.psm1' #Module for vtx channel mapping, Smart Audio/IRC Tramp

$CurrentVersion = "3.2.6"

Function CheckForUpdates(){
    param (
        [parameter(Mandatory=$true)][version]$CurrentVersion
    )

    $configJSON = iwr -Uri https://raw.githubusercontent.com/tedelm/PowershellFalcox/master/misc/config.json | ConvertFrom-Json

    $LatestVersion = $configJSON.PowershellLovesFalcox.Version | select -First 1
    $LatestVersionChanges = $configJSON.PowershellLovesFalcox.News | select -First 1

    If([version]$LatestVersion -gt $CurrentVersion){
        Write-Host "Current version - $CurrentVersion"
        Write-Host "New Version Available - $LatestVersion"
        Write-Host "Changes: "
        Write-Host "$LatestVersionChanges"
        $Download = Read-Host "Do you want to download? [y/n]"

        If($Download -match "y"){
            #Download full
            iwr -Uri https://github.com/tedelm/PowershellFalcox/blob/master/FalcoXLovesPowershell.zip?raw=true -OutFile "C:\Users\$($env:USERNAME)\desktop\FalcoXLovesPowershell.zip"
            #Unpack full
            Expand-Archive -LiteralPath "C:\Users\$($env:USERNAME)\desktop\FalcoXLovesPowershell.zip" -DestinationPath "C:\Users\$($env:USERNAME)\desktop\FalcoXLovesPowerShell" -force
            explorer.exe "C:\Users\$($env:USERNAME)\desktop\FalcoXLovesPowerShell"
        }
    }Else{
        Write-Host "Current Version - $CurrentVersion"
        Write-Host "Latest Available Version - $LatestVersion"

    }
}

#Check for updates
CheckForUpdates -CurrentVersion $CurrentVersion

####
####
# Main function for getting config from FC
####
####


Function Get-FalcoXHelp {
    param (
        [string]$Function
    )

  if(!$Function){
    Write-Host " "
    Write-Host "###  FalcoXHelp  ###"
    Write-Host "Available functions:"
    Write-Host " "
    Write-Host "  Get-FalcoXConfig"
    Write-Host "  Get-FalcoXConfigLocal"
    Write-Host "  Set-FalcoXConfig"
    Write-Host "  Setup-FalcoX"
    Write-Host "  Export-FalcoXReportHtml"
    Write-Host " "
    Write-Host " Get-FalcoXHelp -Function 'function'"
    Write-Host " e.g. Get-FalcoXHelp -Function 'Set-FalcoXConfig'"
    Write-Host " "
    Write-Host " "
  }
    switch ($Function) {
        "Get-FalcoXConfig"  {"
            Get-FalcoXConfig -comPort com7 -All

            #Create backup
            Get-FalcoXConfig -comPort COM7 -Dump -Outputfile .\MyFalcoXBackup.txt"}
        "Get-FalcoXConfigLocal"   {"
            Get-FalcoXConfigLocal -InputFile 'C:\MyFalcoXDump.txt' -PIDs -Filters -Rates -TPA -RawConfig"}
        "Set-FalcoXConfig"   {"
            #Set PIDs
            Set-FalcoXConfig -comPort com7 -PIDroll 65,45,175 -PIDpitch 64,45,175 -PIDyaw 58,45,0

            #Set Filter
            Set-FalcoXConfig -comPort com7 -Filter1 'Frequency' -Filter2 'Dynamic' 
            Set-FalcoXConfig -comPort com7 -Filter1Freq 240 -Filter2Freq 105 -DFilter1 'BiQuad' -DFilter2 'BiQuad' -DFilter1Freq 200 -DFilter2Freq 200

            #Restore from backup
            Set-FalcoXConfig -comPort COM7 -Restore -RestoreFilePath .\MyFalcoXBackup.txt"}
        "Setup-FalcoX"   {"
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
        "}
        "Export-FalcoXReportHtml"   {"
            #Export your configuration to html formated page
            Export-FalcoXReportHtml -comPort com7"}             
    }

}



Function Get-FalcoXConfig {
    param (
        [parameter(Mandatory=$false)][string]$comPort,
        [int]$Waitms,
        [switch]$All,
        [switch]$VtxChannel,
        [switch]$PilotName,
        [switch]$Filters,
        [switch]$Dump,
        [switch]$PIDs,
        [switch]$Rates,
        [switch]$TPA,
        [switch]$FWVersion,
        [switch]$AllTable,
        [string]$Outputfile
    )

    #Autodetect COM-port
    if(!$comPort){
        Write-Host "Autodetecting COM-port..."
        $comPort = (Get-WMIObject Win32_SerialPort | where{($_.PNPDeviceID -like "USB\VID_0483&PID_5740*")}).DeviceID

        if($comPort -match "com"){
            Write-Host "Autodetecting COM-port...Found $comPort"
        }else{
            Write-Host "Autodetecting COM-port...FAILED, exiting"
            break
        }
    }

    #Always dump config
    $FalcoXOnlineDump = Get-FalcoXCOMPortDump -comPort $comPort
    $FalcoXOnlineDump = ($FalcoXOnlineDump) -split "SET ","" -replace '"','' -replace "\[" -replace "\]"
    $FalcoXOnlineDump = $FalcoXOnlineDump.trim()
    $FalcoXOnlineDump = $FalcoXOnlineDump | ?{$_ -notmatch "#OK"} | select -Skip 1

    #Parse file
    $FalcoXTable = New-Object PSObject
    Foreach($contentLine in $FalcoXOnlineDump){$FalcoXTable | Add-Member NoteProperty -Name "$($($contentLine -split '=')[0])" -Value "$($($contentLine -split '=')[1])" -ErrorAction silentlycontinue}

    #Show All
    If($All){
        $All = $true
        $VtxChannel = $true
        $PilotName = $true
        $Filters = $true
        $PIDs = $true
        $Rates = $true
        $TPA = $true
        $FWVersion = $true
    }

    #Show All table Formated
    If($AllTable){
        $VersionOutput = Get-FalcoXCOMPortReadLine -comPort $comPort -InputString "version"
        $VersionOutput = [string]$VersionOutput -split ":" -replace " ","_"
        $FalcoXTable | Add-Member NoteProperty -Name "$($VersionOutput[0])" -Value "$($VersionOutput[1])" -ErrorAction silentlycontinue
        $FalcoXTable
    }

    #Get version
    If($FWVersion){
        $VersionOutput = Get-FalcoXCOMPortReadLine -comPort $comPort -InputString "version"
        Write-Host "----- Version -----"
        Write-Host $VersionOutput
        Write-Host "-----------------"
    }

    #Get pilotname
    If($PilotName){

        $PilotName_tbl = $FalcoXTable | select "name_pilot"
        Write-Host "----- PilotName -----"
        Write-Host $($PilotName_tbl.name_pilot)
        Write-Host "-----------------"
    }
    #Get vtx channel
    If($VtxChannel){
        $VtxChannel_tbl = $FalcoXTable | select "vtx_channel"
        
        Write-Host "----- VTX Settings -----"
        Write-Host "VTX Channel: $(Get-VTXChannelMapping -SmartAudio $($VtxChannel_tbl.vtx_channel))"
        Write-Host "-----------------"
    }
    #Get all settings - raw dump
    If($Dump){
        Get-FalcoXCOMPortDump -comPort $comPort | Out-File -FilePath "$($Outputfile)"

    }
    #Get filters
    If($Filters){

        $Filters_tbl = $FalcoXTable | select "filt1_type","filt1_freq","filt2_type","filt2_freq","dfilt1_type","dfilt1_freq","dfilt2_freq","dyn_lpf_scale","use_dyn_aa","aa_strength"
        Write-Host "----- Gyro -----"
        Write-Host "Filter1: $(FilterNumb -Filterint $($Filters_tbl.filt1_type)) @ $($Filters_tbl.filt1_freq) Hz"
        Write-Host "Filter2: $(FilterNumb -Filterint $($Filters_tbl.filt2_type)) @ $($Filters_tbl.filt2_freq) Hz"
        Write-Host "Dynamic filter Strenght: $($Filters_tbl.dyn_lpf_scale)"

        Write-Host "----- D-Term -----"
        Write-Host "Filter1: $(FilterNumb -Filterint $($Filters_tbl.dfilt1_type)) @ $($Filters_tbl.dfilt1_freq) Hz"
        Write-Host "Filter2: $(FilterNumb -Filterint $($Filters_tbl.dfilt2_type)) @ $($Filters_tbl.dfilt2_freq) Hz"

        Write-Host "-- Dynamic AA ---"
        If($($Filters_tbl.use_dyn_aa) -match "1"){$DynamicAAEnabled = "True"}else{$DynamicAAEnabled = "False"}
        Write-Host "Dynamic AA Enabled: $DynamicAAEnabled"
        Write-Host "Dynamic AA Strength: $($Filters_tbl.aa_strength)"
        Write-Host "-----------------"
    }
    #Output PIDs
    If($PIDs){

        $PIDs_tbl = $FalcoXTable | select "roll_p","roll_i","roll_d","pitch_p","pitch_i","pitch_d","yaw_p","yaw_i","yaw_d","use_simmode","use_whisper","sim_boost"
        Write-Host "-- PIDs ---"
        Write-host "       P     I     D "
        Write-host "Roll:  $($PIDs_tbl.roll_p),  $($PIDs_tbl.roll_i),  $($PIDs_tbl.roll_d)"
        Write-host "Pitch: $($PIDs_tbl.pitch_p),  $($PIDs_tbl.pitch_i),  $($PIDs_tbl.pitch_d)"
        Write-host "Yaw:   $($PIDs_tbl.yaw_p),  $($PIDs_tbl.yaw_i),  $($PIDs_tbl.yaw_d)"
        
        Write-host "-- PID Controller --"
        If($($PIDs_tbl.use_simmode) -match "1"){$SimmodeEnabled = "True"}else{$SimmodeEnabled = "False"}
        If($($PIDs_tbl.use_whisper) -match "1"){$WhisperEnabled = "True"}else{$WhisperEnabled = "False"}
        Write-host "Sim mode:   $($SimmodeEnabled)"
        Write-host "Sim Boost:   $($PIDs_tbl.sim_boost)"
        Write-host "Whisper: $($WhisperEnabled)"
        Write-Host "-----------------"
    }

    #Output Rates
    If($Rates){

        $Rates_tbl = $FalcoXTable | select "pitch_rate1","roll_rate1","yaw_rate1","pitch_acrop1","roll_acrop1","yaw_acrop1","pitch_expo1","roll_expo1","yaw_expo1","rc_smoothing_type","rc_smoothing_value"
        Write-Host "-- Rates ---"
        Write-host "----- RATE, EXPO, ACRO -----"
        Write-host "Roll: $($Rates_tbl.roll_rate1), $($Rates_tbl.roll_expo1), $($Rates_tbl.roll_acrop1)"
        Write-host "Pitch: $($Rates_tbl.pitch_rate1), $($Rates_tbl.pitch_expo1), $($Rates_tbl.pitch_acrop1)"
        Write-host "Yaw: $($Rates_tbl.yaw_rate1), $($Rates_tbl.yaw_expo1),$($Rates_tbl.yaw_acrop1)"

        $CalcRollRate = [int]($Rates_tbl.roll_rate1) + ([int]($Rates_tbl.roll_rate1) * [decimal]($Rates_tbl.roll_expo1))
        $CalcPitchRate = [int]($Rates_tbl.pitch_rate1) + ([int]$($Rates_tbl.pitch_rate1) * [decimal]($Rates_tbl.roll_expo1))
        $CalcYawRate = [int]($Rates_tbl.yaw_rate1) + ([int]$($Rates_tbl.yaw_rate1) * [decimal]($Rates_tbl.roll_expo1))            
        Write-host "Roll deg/sec: $CalcRollRate"
        Write-host "Pitch deg/sec: $CalcPitchRate"
        Write-host "Yaw deg/sec: $CalcYawRate"              
        Write-host "----- RC Smooth -----"
        Write-host "RC Smooth type: $($Rates_tbl.rc_smoothing_type)"
        Write-host "RC Smooth: $($Rates_tbl.rc_smoothing_value)"   
  
        Write-Host "-----------------"
    }
    #Output TPA
    IF($TPA){
        
        $TPA_tbl = $FalcoXTable | select "*_curve*"
        Write-Host "-- TPA ---"
        "Throttle: 0-100%"
        "P: $($TPA_tbl.p_curve0),$($TPA_tbl.p_curve1),$($TPA_tbl.p_curve2),$($TPA_tbl.p_curve3),$($TPA_tbl.p_curve4),$($TPA_tbl.p_curve5),$($TPA_tbl.p_curve6),$($TPA_tbl.p_curve7),$($TPA_tbl.p_curve8),$($TPA_tbl.p_curve9),$($TPA_tbl.p_curve10)"
        "I: $($TPA_tbl.i_curve0),$($TPA_tbl.i_curve1),$($TPA_tbl.i_curve2),$($TPA_tbl.i_curve3),$($TPA_tbl.i_curve4),$($TPA_tbl.i_curve5),$($TPA_tbl.i_curve6),$($TPA_tbl.i_curve7),$($TPA_tbl.i_curve8),$($TPA_tbl.i_curve9),$($TPA_tbl.i_curve10)"
        "D: $($TPA_tbl.d_curve0),$($TPA_tbl.d_curve1),$($TPA_tbl.d_curve2),$($TPA_tbl.d_curve3),$($TPA_tbl.d_curve4),$($TPA_tbl.d_curve5),$($TPA_tbl.d_curve6),$($TPA_tbl.d_curve7),$($TPA_tbl.d_curve8),$($TPA_tbl.d_curve9),$($TPA_tbl.d_curve10)"
        Write-Host "-----------------"
    }

    
}
####
####
#Main function for Seting config directly to FC
####
####

Function Set-FalcoXConfig {
    param (
        [parameter(Mandatory=$false)][string]$comPort,
        [parameter(Mandatory=$false)][string]$VtxChannel,
        [parameter(Mandatory=$false)][string]$PilotName,
        [parameter(Mandatory=$false)][array]$LedColor,
        [parameter(Mandatory=$false)][array]$PIDroll,
        [parameter(Mandatory=$false)][array]$PIDpitch,
        [parameter(Mandatory=$false)][array]$PIDyaw,
        [parameter(Mandatory=$false)][int]$Filter1Freq,
        [parameter(Mandatory=$false)][string]$Filter1,
        [parameter(Mandatory=$false)][int]$Filter2Freq,
        [parameter(Mandatory=$false)][string]$Filter2,
        [parameter(Mandatory=$false)][int]$DFilter1Freq,
        [parameter(Mandatory=$false)][string]$DFilter1,
        [parameter(Mandatory=$false)][int]$DFilter2Freq,
        [parameter(Mandatory=$false)][string]$DFilter2,
        [parameter(Mandatory=$false)][switch]$Restore,
        [parameter(Mandatory=$false)][String]$RestoreFilePath
    )

    #Autodetect COM-port
    if(!$comPort){
        Write-Host "Autodetecting COM-port..."
        $comPort = (Get-WMIObject Win32_SerialPort | where{($_.PNPDeviceID -like "USB\VID_0483&PID_5740*")}).DeviceID

        if($comPort -match "com"){
            Write-Host "Autodetecting COM-port...Found $comPort"
        }else{
            Write-Host "Autodetecting COM-port...FAILED, exiting"
            break
        }
    }    

    #Set "VTX Channel"
    If($VtxChannel){
        Write-Host "Setting vtx"
        $SetVtxChannelLookup = (Get-VTXChannelMapping -SmartAudio $VtxChannel)[0]
        Set-FalcoXCOMPortWriteLine -comPort $comPort -inputString "SET vtx_channel=$($SetVtxChannelLookup)"
    }
    #Set pilotname
    If($PilotName){
        Write-Host "Setting Pilot name"
        Set-FalcoXCOMPortWriteLine -comPort $comPort -inputString "SET name_pilot=$($PilotName)"

    }
    #Set Led color
    If($LedColor){
        Write-Host "Setting LED Color"
        Write-Host "led_red=$($LedColor[0])","led_green=$($LedColor[1])","led_blue=$($LedColor[2])"
        Set-FalcoXCOMPortWriteLine -comPort $comPort -inputString "SET led_red=$($LedColor[0])","SET led_green=$($LedColor[1])","SET led_blue=$($LedColor[2])"
    }
    #Set pids Roll
    If($PIDroll){
        Write-Host "Setting PIDs Roll"
        Write-Host "P: $($PIDroll[0]), I: $($PIDroll[1]), D: $($PIDroll[2])"
        If($(($PIDpitch).count) -eq 3){
            Set-FalcoXCOMPortWriteLine -comPort $comPort -inputString "SET roll_p=$($PIDroll[0])","SET roll_i=$($PIDroll[1])","SET roll_d=$($PIDroll[2])"
        }Else{Write-Host "Please enter all P-I-D for Roll"}
    }
    #Set pids Pitch
    If($PIDpitch){
        Write-Host "Setting PIDs Pitch"
        Write-Host "P: $($PIDpitch[0]), I: $($PIDpitch[1]), D: $($PIDpitch[2])"
        If($(($PIDpitch).count) -eq 3){
            Set-FalcoXCOMPortWriteLine -comPort $comPort -inputString "SET pitch_p=$($PIDpitch[0])","SET pitch_i=$($PIDpitch[1])","SET pitch_d=$($PIDpitch[2])"
        }Else{Write-Host "Please enter all P-I-D for Pitch"}
    }
    #Set pids Yaw
    If($PIDyaw){
        Write-Host "Setting PIDs Yaw"
        Write-Host "P: $($PIDyaw[0]), I: $($PIDyaw[1]), D: $($PIDyaw[2])"
        If($(($PIDyaw).count) -eq 3){
            Set-FalcoXCOMPortWriteLine -comPort $comPort -inputString "SET yaw_p=$($PIDyaw[0])","SET yaw_i=$($PIDyaw[1])","SET yaw_d=$($PIDyaw[2])"
        }Else{Write-Host "Please enter all P-I-D for Yaw"}
        

    }
    #Set gyro filter 1 freq
    If($Filter1Freq){
        Write-Host "Setting Gyro Filter Freq"  
        Set-FalcoXCOMPortWriteLine -comPort $comPort -inputString "SET filt1_freq=$($Filter1Freq)"

    }
    #Set gyro filter 1 name
    If($Filter1){
        Write-Host "Setting Gyro Filter 1"  
        $Filter1_int = Get-FilterNameTable -FilterName $Filter1
        If($Filter1_int){
            Set-FalcoXCOMPortWriteLine -comPort $comPort -inputString "SET filt1_type=$($Filter1_int)"
        }
    }
    #Set gyro filter 2 freq
    If($Filter2Freq){
        Write-Host "Setting Gyro Filter Freq"  
        Set-FalcoXCOMPortWriteLine -comPort $comPort -inputString "SET filt2_freq=$($Filter2Freq)"

    }
    #Set gyro filter 2 name
    If($Filter2){
        Write-Host "Setting Gyro Filter 2"  
        $Filter2_int = Get-FilterNameTable -FilterName $Filter2
        If($Filter2_int){
            Set-FalcoXCOMPortWriteLine -comPort $comPort -inputString "SET filt2_type=$($Filter2_int)"
        }
    }
    #Set D-term filter 1 freq
    If($DFilter1Freq){
        Write-Host "Setting D-term Filter Freq"  
        Set-FalcoXCOMPortWriteLine -comPort $comPort -inputString "SET dfilt1_freq=$($DFilter1Freq)"

    }
    #Set D-term filter 1
    If($DFilter1){
        Write-Host "Setting D-term Filter"  
        $DFilter1_int = Get-FilterNameTable -FilterName $DFilter1
        If($DFilter1_int){
            Set-FalcoXCOMPortWriteLine -comPort $comPort -inputString "SET dfilt1_type=$($DFilter1_int)"
        }
    }
    #Set D-term filter 2 freq
    If($DFilter2Freq){
        Write-Host "Setting D-term Filter Freq"  
        Set-FalcoXCOMPortWriteLine -comPort $comPort -inputString "SET dfilt2_freq=$($DFilter2Freq)"

    }
    #Set D-term filter 2
    If($DFilter2){
        Write-Host "Setting D-term Filter"  
        $DFilter2_int = Get-FilterNameTable -FilterName $DFilter2
        If($DFilter2_int){
            Set-FalcoXCOMPortWriteLine -comPort $comPort -inputString "SET dfilt2_type=$($DFilter2_int)"
        }
    }
    #Restore from backup
    If($Restore){
        Write-Host "Restoring from backup"  
        
        If(Test-Path "$($RestoreFilePath)"){

            Set-FalcoXCOMPortWriteDump -comPort $comPort -inputString $(Get-Content $RestoreFilePath)
                
        }
    }     

}


function Export-FalcoXReportHtml {
    param (
        [parameter(Mandatory=$false)][string]$comPort,
        [string]$Outputfile = "C:\Users\$env:USERNAME\FalcoXReport_$(Get-Date -format 'yyyyMMdd_HHmmss').html"
    )

    #Autodetect COM-port
    if(!$comPort){
        Write-Host "Autodetecting COM-port..."
        $comPort = (Get-WMIObject Win32_SerialPort | where{($_.PNPDeviceID -like "USB\VID_0483&PID_5740*")}).DeviceID

        if($comPort -match "com"){
            Write-Host "Autodetecting COM-port...Found $comPort"
        }else{
            Write-Host "Autodetecting COM-port...FAILED, exiting"
            break
        }
    }

    #Always dump config
    $FalcoXOnlineDump = Get-FalcoXCOMPortDump -comPort $comPort
    $FalcoXOnlineDump = ($FalcoXOnlineDump) -split "SET ","" -replace '"','' -replace "\[" -replace "\]"
    $FalcoXOnlineDump = $FalcoXOnlineDump.trim()
    $FalcoXOnlineDump = $FalcoXOnlineDump | ?{$_ -notmatch "#OK"} | select -Skip 1

    #Parse file
    $FalcoXTable = New-Object PSObject
    Foreach($contentLine in $FalcoXOnlineDump){$FalcoXTable | Add-Member NoteProperty -Name "$($($contentLine -split '=')[0])" -Value "$($($contentLine -split '=')[1])" -ErrorAction silentlycontinue}

    #Get falcox version
    $VersionOutput = Get-FalcoXCOMPortReadLine -comPort $comPort -InputString "version"

    Write-Host "Report exported to: $Outputfile"

    $PIDs_tbl = $FalcoXTable | select "roll_p","roll_i","roll_d","pitch_p","pitch_i","pitch_d","yaw_p","yaw_i","yaw_d","use_simmode","use_whisper","sim_boost","cg_comp", "smooth_stop"
    
    #PID Controller
    If($($PIDs_tbl.use_simmode) -match "1"){$SimmodeEnabled = "True"}else{$SimmodeEnabled = "False"}
    If($($PIDs_tbl.use_whisper) -match "1"){$WhisperEnabled = "True"}else{$WhisperEnabled = "False"}
    
    #Pilot name
    $Misc_tbl = $FalcoXTable | select "name_pilot", "idle_percent", "esc_protocol"
    #$Misc_tbl.name_pilot
    

    #Filters
    $Filters_tbl = $FalcoXTable | select "filt1_type","filt1_freq","filt2_type","filt2_freq","dfilt1_type","dfilt1_freq","dfilt2_freq","dyn_lpf_scale","use_dyn_aa","aa_strength","d_term_aa_strength"
    If( $($Filters_tbl.use_dyn_aa) -match "1"){$DynamicAAEnabled = "True"}else{$DynamicAAEnabled = "False"}
        

    $TPA_tbl = $FalcoXTable | select "*_curve*"

    $Rate_tbl = $FalcoXTable | select "*_rate*","*_acrop*","*_expo*"

    #Create HTML
    $html = "
    <html>
    <head>
    <title>$title</title>
    <style>
    table.default {
    font-family: Arial, Helvetica, sans-serif;
    border-collapse: collapse;
    border: 1px solid black;
    }
    th.th_headline {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 15px;
    font-weight: bold;
    }
    td.td_headline {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 15px;
    font-weight: bold;
    }
    td {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 15px;
    border: 1px solid black;
    }

    </style>
    </head>
    <body>
    $Body


    <table class='Default'>
        <tr>
            <th>$VersionOutput</th><th></th><th></th><th>ROLL</th><th>PITCH</th><th>YAW</th><th>TPA</th><th>P</th><th>I</th><th>D</th>
        </tr>      
        <tr>
            <td class='td_headline'>FILT1</td><td>$(FilterNumb -Filterint $($Filters_tbl.filt1_type))</td><td class='td_headline' align='center'>P</td><td>$($PIDs_tbl.roll_p)</td><td>$($PIDs_tbl.pitch_p)</td><td>$($PIDs_tbl.yaw_p)</td><td>0%</td><td>$($TPA_tbl.p_curve0)</td><td>$($TPA_tbl.i_curve0)</td><td>$($TPA_tbl.d_curve0)</td>
        </tr>
        <tr>
            <td class='td_headline'>FILT2</td><td>$(FilterNumb -Filterint $($Filters_tbl.filt2_type))</td><td class='td_headline' align='center'>I</td><td>$($PIDs_tbl.roll_i)</td><td>$($PIDs_tbl.pitch_i)</td><td>$($PIDs_tbl.yaw_i)</td><td>10%</td><td>$($TPA_tbl.p_curve1)</td><td>$($TPA_tbl.i_curve1)</td><td>$($TPA_tbl.d_curve1)</td>
        </tr>
        <tr>
            <td class='td_headline'>DFILT1</td><td>$(FilterNumb -Filterint $($Filters_tbl.dfilt1_type))</td><td class='td_headline' align='center'>D</td><td>$($PIDs_tbl.roll_d)</td><td>$($PIDs_tbl.pitch_d)</td><td>$($PIDs_tbl.yaw_d)</td><td>20%</td><td>$($TPA_tbl.p_curve2)</td><td>$($TPA_tbl.i_curve2)</td><td>$($TPA_tbl.d_curve2)</td>
        </tr>
        <tr>
            <td class='td_headline'>DFILT2</td><td>$(FilterNumb -Filterint $($Filters_tbl.dfilt2_type))</td><td></td><td></td><td></td><td></td><td>30%</td><td>$($TPA_tbl.p_curve3)</td><td>$($TPA_tbl.i_curve3)</td><td>$($TPA_tbl.d_curve3)</td>
        </tr>
        <tr>
            <td class='td_headline'>FILT1 (Hz)</td><td>$($Filters_tbl.filt1_freq)</td><td class='td_headline'>SIM</td><td>$SimmodeEnabled</td><td></td><td></td><td>40%</td><td>$($TPA_tbl.p_curve4)</td><td>$($TPA_tbl.i_curve4)</td><td>$($TPA_tbl.d_curve4)</td>
        </tr>
        <tr>
            <td class='td_headline'>FILT2 (Hz)</td><td>$($Filters_tbl.filt2_freq)</td><td class='td_headline'>SIM BOOST</td><td>$($PIDs_tbl.sim_boost)</td><td></td><td></td><td>50%</td><td>$($TPA_tbl.p_curve5)</td><td>$($TPA_tbl.i_curve5)</td><td>$($TPA_tbl.d_curve5)</td>
        </tr>
        <tr>
            <td class='td_headline'>DFILT1 (Hz)</td><td>$($Filters_tbl.dfilt1_freq)</td><td class='td_headline'>WHISPER</td><td>$WhisperEnabled</td><td></td><td></td><td>60%</td><td>$($TPA_tbl.p_curve6)</td><td>$($TPA_tbl.i_curve6)</td><td>$($TPA_tbl.d_curve6)</td>
        </tr>
        <tr>
            <td class='td_headline'>DFILT2 (Hz)</td><td>$($Filters_tbl.dfilt2_freq)</td><td class='td_headline'>CG COMP</td><td>$($PIDs_tbl.cg_comp)</td><td></td><td></td><td>70%</td><td>$($TPA_tbl.p_curve7)</td><td>$($TPA_tbl.i_curve7)</td><td>$($TPA_tbl.d_curve7)</td>
        </tr>
        <tr>
            <td class='td_headline'>DYNAMIC AA</td><td>$DynamicAAEnabled</td><td class='td_headline'>SMOOTH STOP</td><td>$($PIDs_tbl.smooth_stop)</td><td></td><td></td><td>80%</td><td>$($TPA_tbl.p_curve8)</td><td>$($TPA_tbl.i_curve8)</td><td>$($TPA_tbl.d_curve8)</td>
        </tr>
        <tr>
            <td class='td_headline'>AA STRENGTH</td><td>$($Filters_tbl.aa_strength)</td><td class='td_headline'>Idle %</td><td>$($Misc_tbl.idle_percent)</td><td></td><td></td><td>90%</td><td>$($TPA_tbl.p_curve9)</td><td>$($TPA_tbl.i_curve9)</td><td>$($TPA_tbl.d_curve9)</td>
        </tr>		
        <tr>
            <td class='td_headline'>DYNAMIC FILT STRENGTH</td><td>$($Filters_tbl.dyn_lpf_scale)</td><td class='td_headline'>ESC proto</td><td>$(Get-FalcoXEscProto -ProtocolInt $($Misc_tbl.esc_protocol))</td><td></td><td></td><td>100%</td><td>$($TPA_tbl.p_curve10)</td><td>$($TPA_tbl.i_curve10)</td><td>$($TPA_tbl.d_curve10)</td>
        </tr>
        <tr>
            <td class='td_headline'>DFILT AA STRENGTH</td><td>$(Get-FalcoXDfiltStrength -ProtocolInt $($Filters_tbl.d_term_aa_strength))</td><td class='td_headline'></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
        </tr>                                                             	
    </table>
    <table class='Default'>
        <tr>
            <td class='td_headline'></td><td class='td_headline'>PITCH</td><td class='td_headline'>ROLL</td><td class='td_headline'>YAW</td>
        </tr>    
        <tr>
            <td class='td_headline'>RATE</td><td>$($Rate_tbl.pitch_rate1)</td><td>$($Rate_tbl.roll_rate1)</td><td>$($Rate_tbl.yaw_rate1)</td>
        </tr>
        <tr>
            <td class='td_headline'>ACRO</td><td>$($Rate_tbl.pitch_acrop1)</td><td>$($Rate_tbl.roll_acrop1)</td><td>$($Rate_tbl.yaw_acrop1)</td>
        </tr>    
        <tr>
            <td class='td_headline'>EXPO</td><td>$($Rate_tbl.pitch_expo1)</td><td>$($Rate_tbl.roll_expo1)</td><td>$($Rate_tbl.yaw_expo1)</td>
        </tr>
        <tr>
            <td class='td_headline'>DEG. SEC</td><td> $(Get-FalcoXRateCalc -Rate $($Rate_tbl.pitch_rate1) -Expo $($Rate_tbl.pitch_expo1) -Acro $($Rate_tbl.pitch_acrop1)) </td>
                                                 <td> $(Get-FalcoXRateCalc -Rate $($Rate_tbl.roll_rate1) -Expo $($Rate_tbl.roll_expo1) -Acro $($Rate_tbl.roll_acrop1)) </td>
                                                 <td> $(Get-FalcoXRateCalc -Rate $($Rate_tbl.yaw_rate1) -Expo $($Rate_tbl.yaw_expo1) -Acro $($Rate_tbl.yaw_acrop1)) </td>
        </tr>        
    </table>    
"
        
    $html | Out-File -FilePath $Outputfile -Encoding UTF8
    start $Outputfile    

    
}



####
####
# Main function for local .txt config file
####
####
Function Get-FalcoXConfigLocal {
    param (
        [String]$InputFile,
        [switch]$RawConfig,
        [switch]$VtxChannel,
        [switch]$PIDs,
        [switch]$Filters,
        [switch]$Pilotname,
        [switch]$Rates,
        [switch]$TPA
    )

    $InputFile
    $InputFile_clean = (Get-Content $InputFile) -split "," -replace "SET ","" -replace '"','' -replace "\[" -replace "\]"
    
    #Output raw config to screen
    If($RawConfig){$InputFile_clean}

    #Parse file
    $FalcoXTable = New-Object PSObject
    Foreach($contentLine in $InputFile_clean){$FalcoXTable | Add-Member NoteProperty -Name "$($($contentLine -split '=')[0])" -Value "$($($contentLine -split '=')[1])" -ErrorAction silentlycontinue}

    #Output VTX channel and freq
    If($VtxChannel){
        $VtxChannel_tbl = $FalcoXTable | select "vtx_protocol","vtx_model","enable_vtx_channel","enable_vtx_value","vtx_channel","vtx_power","vtx_pit","vtx_kill_ch"
        Get-VTXChannelMapping -SmartAudio $VtxChannel
    }

    #Output PIDs
    If($PIDs){
        $PIDs_tbl = $FalcoXTable | select "roll_p","roll_i","roll_d","pitch_p","pitch_i","pitch_d","yaw_p","yaw_i","yaw_d"
        Write-host "       P     I     D "
        Write-host "Roll:  $($PIDs_tbl.roll_p),  $($PIDs_tbl.roll_i),  $($PIDs_tbl.roll_d)"
        Write-host "Pitch: $($PIDs_tbl.pitch_p),  $($PIDs_tbl.pitch_i),  $($PIDs_tbl.pitch_d)"
        Write-host "Yaw:   $($PIDs_tbl.yaw_p),  $($PIDs_tbl.yaw_i),  $($PIDs_tbl.yaw_d)"
    }
    #Output Filters
    If($Filters){
        $Filters_tbl = $FalcoXTable | select "filt1_type","filt1_freq","filt2_type","filt2_freq","dfilt1_type","dfilt1_freq","dfilt2_freq","dyn_lpf_scale","use_dyn_aa","aa_strength"
        
        Write-Host "----- Gyro -----"
        Write-Host "Filter1: $(FilterNumb -Filterint $($Filters_tbl.filt1_type)) @ $($Filters_tbl.filt1_freq) Hz"
        Write-Host "Filter2: $(FilterNumb -Filterint $($Filters_tbl.filt2_type)) @ $($Filters_tbl.filt2_freq) Hz"
        Write-Host "Dynamic filter Strenght: $($Filters_tbl.dyn_lpf_scale)"

        Write-Host "----- D-Term -----"
        Write-Host "Filter1: $(FilterNumb -Filterint $($Filters_tbl.dfilt1_type)) @ $($Filters_tbl.dfilt1_freq) Hz"
        Write-Host "Filter1: $(FilterNumb -Filterint $($Filters_tbl.dfilt2_type)) @ $($Filters_tbl.dfilt2_freq) Hz"

        Write-Host "-- Dynamic AA ---"
        If($($Filters_tbl.use_dyn_aa) -match "1"){$DynamicAAEnabled = "True"}else{$DynamicAAEnabled = "False"}
        Write-Host "Dynamic AA Enabled: $DynamicAAEnabled"
        Write-Host "Dynamic AA Strength: $($Filters_tbl.aa_strength)"
    }
    #Output Pilotname
    If($Pilotname){$Pilotname_tbl = $FalcoXTable | select "name_pilot"; $($Pilotname_tbl.name_pilot)}

    #Output Rates
    If($Rates){
        $Rates_tbl = $FalcoXTable | select "pitch_rate1","roll_rate1","yaw_rate1","pitch_acrop1","roll_acrop1","yaw_acrop1","pitch_expo1","roll_expo1","yaw_expo1","rc_smoothing_type","rc_smoothing_value"
        Write-Host "-- Rates ---"
        Write-host "----- RATE, ACRO, EXPO -----"
        Write-host "Roll: $($Rates_tbl.roll_rate1), $($Rates_tbl.roll_acrop1), $($Rates_tbl.roll_expo1)"
        Write-host "Pitch: $($Rates_tbl.pitch_rate1), $($Rates_tbl.pitch_acrop1), $($Rates_tbl.pitch_expo1)"
        Write-host "Yaw: $($Rates_tbl.yaw_rate1), $($Rates_tbl.yaw_acrop1), $($Rates_tbl.yaw_expo1)"    
        Write-host "----- RC Smooth -----"
        Write-host "RC Smooth type: $($Rates_tbl.rc_smoothing_type)"
        Write-host "RC Smooth: $($Rates_tbl.rc_smoothing_value)"        

    }
    #Output TPA
    IF($TPA){
        $TPA_tbl = $FalcoXTable | select "*_curve*"
        Write-Host "-- TPA ---"
        "Throttle: 0-100%"
        "P: $($TPA_tbl.p_curve0),$($TPA_tbl.p_curve1),$($TPA_tbl.p_curve2),$($TPA_tbl.p_curve3),$($TPA_tbl.p_curve4),$($TPA_tbl.p_curve5),$($TPA_tbl.p_curve6),$($TPA_tbl.p_curve7),$($TPA_tbl.p_curve8),$($TPA_tbl.p_curve9),$($TPA_tbl.p_curve10)"
        "I: $($TPA_tbl.i_curve0),$($TPA_tbl.i_curve1),$($TPA_tbl.i_curve2),$($TPA_tbl.i_curve3),$($TPA_tbl.i_curve4),$($TPA_tbl.i_curve5),$($TPA_tbl.i_curve6),$($TPA_tbl.i_curve7),$($TPA_tbl.i_curve8),$($TPA_tbl.i_curve9),$($TPA_tbl.i_curve10)"
        "D: $($TPA_tbl.d_curve0),$($TPA_tbl.d_curve1),$($TPA_tbl.d_curve2),$($TPA_tbl.d_curve3),$($TPA_tbl.d_curve4),$($TPA_tbl.d_curve5),$($TPA_tbl.d_curve6),$($TPA_tbl.d_curve7),$($TPA_tbl.d_curve8),$($TPA_tbl.d_curve9),$($TPA_tbl.d_curve10)"

    }

}



Function Setup-FalcoX {
    param (
        [parameter(Mandatory=$false)][string]$comPort,
        [switch]$EnterDFU,
        [switch]$ResetConfig,
        [switch]$ResetWizard,
        [switch]$ResetRadio,
        [string]$SetUARTProtocol,
        [string]$SetUART,
        [switch]$WizardCompleted
    )

    #Autodetect COM-port
    if(!$comPort){
        Write-Host "Autodetecting COM-port..."
        $comPort = (Get-WMIObject Win32_SerialPort | where{($_.PNPDeviceID -like "USB\VID_0483&PID_5740*")}).DeviceID

        if($comPort -match "com"){
            Write-Host "Autodetecting COM-port...Found $comPort"
        }else{
            Write-Host "Autodetecting COM-port...FAILED, exiting"
            break
        }
    }    

    if($EnterDFU){
        Write-Host "Entering DFU mode"
        Set-FalcoXCOMPortFunctions -comPort $comPort -inputString "DFU"
    }
    if($ResetConfig){
        Write-Host "Resetting Config"
        Set-FalcoXCOMPortFunctions -comPort $comPort -inputString "RESETCONFIG"
    }
    if($ResetWizard){
        Write-Host "Resetting Wizard"
        Set-FalcoXCOMPortFunctions -comPort $comPort -inputString "RESET_WIZARD"
        Set-FalcoXCOMPortWriteLine -comPort $comPort -inputString "SET wizard_flags=0"
    }        
    if($WizardCompleted){
        Write-Host "Setting Wizard Completed"
        Set-FalcoXCOMPortWriteLine -comPort $comPort -inputString "SET wizard_flags=127"
    }
    if($SetUARTProtocol){

        if($SetUART){
            Write-Host "Setting Radio Protocol $($SetUART)"
            Write-Host "Only supported in 10.0.6.xxxx or later"
            Set-FalcoXCOMPortWriteLine -comPort $comPort -inputString "SET uart$($SetUART)_protocol=$($SetUARTProtocol)"
        }else{
            Write-Host "Please provide '-SetUART' as well"
        }

    }

    
   
}

#Setup-FalcoX -comPort com10 -SetUART 1 -SetUARTProtocol 2


function Get-FalcoXOSD {
    param (
        [parameter(Mandatory=$false)][string]$comPort,
        [switch]$OsdON,
        [switch]$OsdOFF
    )

    #Autodetect COM-port
    if(!$comPort){
        Write-Host "Autodetecting COM-port..."
        $comPort = (Get-WMIObject Win32_SerialPort | where{($_.PNPDeviceID -like "USB\VID_0483&PID_5740*")}).DeviceID

        if($comPort -match "com"){
            Write-Host "Autodetecting COM-port...Found $comPort"
        }else{
            Write-Host "Autodetecting COM-port...FAILED, exiting"
            break
        }
    }

    if($OsdON){
        Set-FalcoXCOMPortWriteLine -comPort $comPort -inputString "OSDON"

        While(1 -eq 1){
            clear
            Get-FalcoXCOMPortDump -comPort $comPort
            start-sleep -Seconds 1
        }
    }
    if($OsdOFF){
        Set-FalcoXCOMPortWriteLine -comPort $comPort -inputString "OSDOFF"

    }
    
    
}

#Get-FalcoXOSD -OsdON

####
####
# Secondary function for getting filter names
####
####
Function FilterNumb($Filterint){
    switch ($Filterint)
    {
        1 { $result = 'BiQuad' }
        2 { $result = 'Frequency' }
        3 { $result = 'Dynamic' }

    }

    $result
}

Function Get-FilterNameTable($FilterName){
    switch ($FilterName)
    {
        BiQuad { $result = 1 }
        Freq { $result = 2 }
        Dyn { $result = 3 }
        Frequency { $result = 2 }
        Dynamic { $result = 3 }

    }

    $result
}

#Esc proto
Function Get-FalcoXEscProto($ProtocolInt){
    switch ($ProtocolInt)
    {
        0 { $result = 'Multishot' }
        1 { $result = 'DSHOT64' }
        2 { $result = 'DSHOT32' }
        3 { $result = 'DSHOT1200' }
        4 { $result = 'DSHOT600' }
        5 { $result = 'DSHOT300' }
        6 { $result = 'Proshot32' }
        7 { $result = 'Proshot16' }
    }

    $result
}

#DFilt strength
Function Get-FalcoXDfiltStrength($ProtocolInt){
    switch ($ProtocolInt)
    {
        0 { $result = 'Disabled' }
        1 { $result = 'Low' }
        2 { $result = 'Medium' }
        3 { $result = 'High' }        
    }

    $result
}


#Rates, deg/sec
function Get-FalcoXRateCalc() {
    param (
        [decimal]$Rate,
        [decimal]$Expo,
        [decimal]$Acro,
        [decimal]$rccmd

    )
    if(!$rccmd){
        #If empty, set to full deflection
        #throttle is from 0 to 1, RcCmd is from -1 to 1
        $rccmd = 1
    }
    

    $curvedRcCommand = ((1.0 + $expo * ($rccmd * $rccmd - 1.0)) * $rccmd)
    $returnRateInDeg = ($curvedRcCommand * ($rate + ($curvedRcCommand * $rate * $acro)))

    [math]::Round($returnRateInDeg,0)

}

#Export-ModuleMember -Function Get-FalcoXConfigLocal
#Export-ModuleMember -Function Get-FalcoXConfig
#Export-ModuleMember -Function Get-FalcoXRateCalc
#Export-ModuleMember -Function Get-FalcoXDfiltStrength
#Export-ModuleMember -Function Get-FalcoXEscProto
#Export-ModuleMember -Function Set-FalcoXConfig
#Export-ModuleMember -Function Export-FalcoXReportHtml
#Export-ModuleMember -Function Setup-FalcoX
#Export-ModuleMember -Function FilterNumb
#Export-ModuleMember -Function Get-FilterNameTable


