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

####
####
# Main function for getting config from FC
####
####
clear
Function GuidedMenu(){
    clear
    Write-Host " * Welcome to FalcoXLovesPowerShell * "
    Write-Host " "
    Write-Host " [1] - Create backup"
    Write-Host " [2] - Restore from backup"
    Write-Host " [3] - View current config"
    Write-Host " [4] - Create HTML Report" 
    Write-Host " [5] - Set CRSF on TX1 (10.0.6.xxxx or later)"
    Write-Host " [6] - Preset tunes - PIDs and Filters"
    Write-Host " [7] - Show connected COM-ports"
    Write-Host " "

    $GuidedMenuAnwser = read-host "Pick a number [1-7]"

    $MostLikelyCOMport = (Get-WMIObject Win32_SerialPort | where{($_.PNPDeviceID -like "USB\VID_0483&PID_5740*")}).DeviceID


    If($GuidedMenuAnwser -eq 1){
        $GuidedMenuAnwser1_1 = read-host "Select COM-port type e.g. 'COM7' or let me guess (default)"
        $GuidedMenuAnwser1_2 = read-host "Backup filename e.g. 'myFalcoXbackup.txt'"
        $GuidedMenuAnwser1_2 

        if(!$GuidedMenuAnwser1_1){
            $ComportToUse = $MostLikelyCOMport
            Write-host "Im guessing your FC is on: $ComportToUse"
        }else{
            $ComportToUse = $GuidedMenuAnwser1_1
        }
        Write-host "Using $ComportToUse"


        Get-FalcoXConfig -comPort "$($ComportToUse)" -Dump -Outputfile "$($GuidedMenuAnwser1_2)"
        Write-Host "Backup command executed"
        $GuidedPressEnter = read-host "Press [Enter] to continue"
        clear  
        GuidedMenu         
    }
    If($GuidedMenuAnwser -eq 2){
        $GuidedMenuAnwser2_1 = read-host "Select COM-port type e.g. 'COM7' or let me guess (default)"
        $GuidedMenuAnwser2_2 = read-host "Restore filename e.g. 'myFalcoXbackup.txt'"

        if(!$GuidedMenuAnwser2_1){
            $ComportToUse = $MostLikelyCOMport
            Write-host "Im guessing your FC is on: $ComportToUse"
        }else{
            $ComportToUse = $GuidedMenuAnwser2_1
        }
        Write-host "Using $ComportToUse"


        Set-FalcoXConfig -comPort "$($ComportToUse)" -Restore -RestoreFilePath "$($GuidedMenuAnwser2_2)"
        Write-Host "Restore command executed"
        $GuidedPressEnter = read-host "Press [Enter] to continue"
        clear 
        GuidedMenu          
    }
    If($GuidedMenuAnwser -eq 3){
        $GuidedMenuAnwser3_1 = read-host "Select COM-port type e.g. 'COM7' or let me guess (default)"

        if(!$GuidedMenuAnwser3_1){
            $ComportToUse = $MostLikelyCOMport
            Write-host "Im guessing your FC is on: $ComportToUse"
        }else{
            $ComportToUse = $GuidedMenuAnwser3_1
        }
        Write-host "Using $ComportToUse"


        Get-FalcoXConfig -comPort "$($ComportToUse)" -All
        $GuidedPressEnter = read-host "Press [Enter] to continue"
        clear 
        GuidedMenu       
    }
    If($GuidedMenuAnwser -eq 4){
        $GuidedMenuAnwser4 = read-host "Select COM-port type e.g. 'COM7' or let me guess (default)"

        if(!$GuidedMenuAnwser4){
            $ComportToUse = $MostLikelyCOMport
            Write-host "Im guessing your FC is on: $ComportToUse"
        }else{
            $ComportToUse = $GuidedMenuAnwser4
        }
        Write-host "Using $ComportToUse"

        Export-FalcoXReportHtml -comPort "$($ComportToUse)"
        $GuidedPressEnter = read-host "Press [Enter] to continue"
        clear 
        GuidedMenu       
    }
    If($GuidedMenuAnwser -eq 5){
        $GuidedMenuAnwser4 = read-host "Select COM-port type e.g. 'COM7' or let me guess (default)"

        if(!$GuidedMenuAnwser4){
            $ComportToUse = $MostLikelyCOMport
            Write-host "Im guessing your FC is on: $ComportToUse"
        }else{
            $ComportToUse = $GuidedMenuAnwser4
        }
        Write-host "Using $ComportToUse"
        
        #Get-UARTMapping -protocol crsf
        Setup-FalcoX -comPort $ComportToUse -SetUART 1 -SetUARTProtocol 2
        $GuidedPressEnter = read-host "Press [Enter] to continue"
        clear 
        GuidedMenu       
    }

    If($GuidedMenuAnwser -eq 6){
        clear
        Write-Host " * Welcome to FalcoXLovesPowerShell * "
        Write-Host " "
        Write-Host " ### Preset PID and Filters ###"
        Write-Host " [1] - Set MRTEEL 4s - Freestyle - PIDs and Filters"
        Write-Host " [2] - Set KIM 6s - Freestyle - PIDs and Filters"
        Write-Host " [C] - Create outputfile with only PIDs,Filters,Rates"
        Write-Host " [Q] - Main menu"
        Write-Host " "
    
        $GuidedMenuAnwserPidsAndFilters = read-host "Pick a number [1-2] or 'Q' for main menu"

        If($GuidedMenuAnwserPidsAndFilters -eq 1){
            $GuidedMenuAnwserPidsAndFiltersPort_1 = read-host "Select COM-port type e.g. 'COM7' or let me guess (default)"
    
            if(!$GuidedMenuAnwserPidsAndFiltersPort_1){
                $ComportToUse = $MostLikelyCOMport
                Write-host "Im guessing your FC is on: $ComportToUse"
            }else{
                $ComportToUse = $GuidedMenuAnwser4
            }
            Write-host "Using $ComportToUse"
    
            #Presets
            $PresetArrayMRTEEL = @("SET deadband=0.014","SET esc_protocol=2","SET idle_percent=6","SET max_throttle=100","SET roll_p=65","SET roll_i=45","SET roll_d=314","SET pitch_p=68","SET pitch_i=45","SET pitch_d=345","SET yaw_p=65","SET yaw_i=45","SET yaw_d=116","SET level_kp=50","SET level_ki=40","SET level_angle=35","SET use_simmode=1","SET use_whisper=1","SET use_dyn_aa=0","SET aa_strength=0","SET d_term_aa_strength=0","SET p_curve0=105.000","SET p_curve1=95.000","SET p_curve2=85.000","SET p_curve3=80.000","SET p_curve4=80.000","SET p_curve5=75.000","SET p_curve6=65.000","SET p_curve7=55.000","SET p_curve8=55.000","SET p_curve9=55.000","SET p_curve10=55.000","SET i_curve0=100.000","SET i_curve1=100.000","SET i_curve2=100.000","SET i_curve3=100.000","SET i_curve4=100.000","SET i_curve5=100.000","SET i_curve6=100.000","SET i_curve7=100.000","SET i_curve8=100.000","SET i_curve9=100.000","SET i_curve10=100.000","SET d_curve0=100.000","SET d_curve1=92.000","SET d_curve2=90.000","SET d_curve3=80.000","SET d_curve4=80.000","SET d_curve5=75.000","SET d_curve6=65.000","SET d_curve7=55.000","SET d_curve8=55.000","SET d_curve9=55.000","SET d_curve10=55.000","SET cg_comp=0.907","SET sim_boost=1.200","SET smooth_stop=0","SET rc_smoothing_type=2","SET rc_smoothing_value=0.250","SET filt1_type=2","SET filt2_type=2","SET dfilt1_type=1","SET dfilt2_type=1","SET filt1_freq=240","SET filt2_freq=105","SET dfilt1_freq=180","SET dfilt2_freq=95","SET dyn_lpf_scale=80","SET pitch_rate1=200.000","SET roll_rate1=200.000","SET yaw_rate1=200.000","SET pitch_acrop1=1.906","SET roll_acrop1=1.906","SET yaw_acrop1=1.807","SET pitch_expo1=0.648","SET roll_expo1=0.648","SET yaw_expo1=0.647")
    
            Set-FalcoXCOMPortWriteLine -comPort $ComportToUse -inputString $PresetArrayMRTEEL
            $GuidedPressEnter = read-host "Press [Enter] to continue"
            clear 
            GuidedMenu       
        }  
        If($GuidedMenuAnwserPidsAndFilters -eq 2){
            $GuidedMenuAnwserPidsAndFiltersPort_2 = read-host "Select COM-port type e.g. 'COM7' or let me guess (default)"
    
            if(!$GuidedMenuAnwserPidsAndFiltersPort_2){
                $ComportToUse = $MostLikelyCOMport
                Write-host "Im guessing your FC is on: $ComportToUse"
            }else{
                $ComportToUse = $GuidedMenuAnwser4
            }
            Write-host "Using $ComportToUse"
    
            #Presets
            $PresetArray = @('SET idle_percent=6', 'SET max_throttle=100', 'SET roll_p=54', 'SET roll_i=50', 'SET roll_d=380', 'SET pitch_p=54', 'SET pitch_i=50', 'SET pitch_d=320', 'SET yaw_p=64', 'SET yaw_i=150', 'SET yaw_d=0', 'SET level_kp=50', 'SET level_ki=40', 'SET level_angle=35', 'SET use_simmode=1', 'SET use_whisper=1', 'SET use_dyn_aa=0', 'SET aa_strength=0', 'SET d_term_aa_strength=2', 'SET p_curve0=100.000', 'SET p_curve1=100.000', 'SET p_curve2=100.000', 'SET p_curve3=100.000', 'SET p_curve4=100.000', 'SET p_curve5=100.000', 'SET p_curve6=100.000', 'SET p_curve7=90.000', 'SET p_curve8=80.000', 'SET p_curve9=70.000', 'SET p_curve10=60.000', 'SET i_curve0=100.000', 'SET i_curve1=100.000', 'SET i_curve2=100.000', 'SET i_curve3=100.000', 'SET i_curve4=100.000', 'SET i_curve5=100.000', 'SET i_curve6=100.000', 'SET i_curve7=100.000', 'SET i_curve8=100.000', 'SET i_curve9=100.000', 'SET i_curve10=100.000', 'SET d_curve0=100.000', 'SET d_curve1=100.000', 'SET d_curve2=100.000', 'SET d_curve3=100.000', 'SET d_curve4=100.000', 'SET d_curve5=100.000', 'SET d_curve6=100.000', 'SET d_curve7=100.000', 'SET d_curve8=90.000', 'SET d_curve9=80.000', 'SET d_curve10=70.000', 'SET cg_comp=0.949', 'SET sim_boost=1.358', 'SET smooth_stop=0', 'SET rc_smoothing_type=2', 'SET rc_smoothing_value=0.158', 'SET filt1_type=2', 'SET filt2_type=2', 'SET dfilt1_type=1', 'SET dfilt2_type=1', 'SET filt1_freq=270', 'SET filt2_freq=100', 'SET dfilt1_freq=120', 'SET dfilt2_freq=240', 'SET dyn_lpf_scale=80', 'SET pitch_rate1=350.000', 'SET roll_rate1=350.000', 'SET yaw_rate1=360.000', 'SET pitch_acrop1=0.898', 'SET roll_acrop1=0.898', 'SET yaw_acrop1=1.100', 'SET pitch_expo1=0.559', 'SET roll_expo1=0.559', 'SET yaw_expo1=0.559')
    
            Set-FalcoXCOMPortWriteLine -comPort $ComportToUse -inputString $PresetArray
            $GuidedPressEnter = read-host "Press [Enter] to continue"
            clear 
            GuidedMenu       
        } 
        If($GuidedMenuAnwserPidsAndFilters -match "C"){
            $GuidedMenuAnwserPidsAndFilters_inputfile = read-host "Inputfile [e.g c:\myFalcoxDump.txt]"
            $GuidedMenuAnwserPidsAndFilters_outputfile = read-host "Outputfile [e.g c:\myFalcoxPids.txt]"
    
            if(!$GuidedMenuAnwserPidsAndFilters_inputfile){
                Write-host "Plese enter Inputfile (dump)"
                $GuidedMenuAnwserPidsAndFilters_inputfile = read-host "Inputfile [e.g c:\myFalcoxDump.txt]"
            }
            if(!$GuidedMenuAnwserPidsAndFilters_outputfile){
                Write-host "Plese enter Inputfile (dump)"
                $GuidedMenuAnwserPidsAndFilters_outputfile = read-host "Outputfile [e.g c:\myFalcoxPids.txt]"
            }            
            
            Write-host "Inputfile: $GuidedMenuAnwserPidsAndFilters_inputfile"
            Write-host "Outputfile with powershell array: $GuidedMenuAnwserPidsAndFilters_outputfile"
            Write-host "Outputfile with only pids,filters and rates: $($GuidedMenuAnwserPidsAndFilters_outputfile).dump"
    
            #Presets
            FalcoXPresetLookup -OutputArrayName '$PresetArray' -inputfile "$($GuidedMenuAnwserPidsAndFilters_inputfile)" -Outputfile $($GuidedMenuAnwserPidsAndFilters_outputfile)
            
            write-host ""
            $GuidedPressEnter = read-host "Press [Enter] to continue"
            clear 
            GuidedMenu       
        }         
        If($GuidedMenuAnwserPidsAndFilters -match "Q"){
            clear 
            GuidedMenu       
        }     
          
    }

    
    If($GuidedMenuAnwser -eq 7){
        Get-FalcoXCOMPort
        Write-Host "I guess that your FC is on $MostLikelyCOMport"
        $GuidedPressEnter = read-host "Press [Enter] to continue"
        clear
        GuidedMenu
    }

    
}


####
####
# Main function for getting config from FC
####
####

Function Get-FalcoXConfig {
    param (
        [parameter(Mandatory=$true)][string]$comPort,
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
        [parameter(Mandatory=$true)][string]$comPort,
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
        [parameter(Mandatory=$true)][string]$comPort,
        [string]$Outputfile = "C:\Users\$env:USERNAME\FalcoXReport_$(Get-Date -format 'yyyyMMdd_HHmmss').html"
    )

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

Function Setup-FalcoX {
    param (
        [parameter(Mandatory=$true)][string]$comPort,
        [switch]$EnterDFU,
        [switch]$ResetConfig,
        [switch]$ResetWizard,
        [switch]$ResetRadio,
        [string]$SetUARTProtocol,
        [string]$SetUART,
        [switch]$WizardCompleted
    )

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



########################

#https://docs.microsoft.com/en-us/windows-hardware/drivers/usbcon/developing-windows-applications-that-communicate-with-a-usb-device
#https://docs.microsoft.com/en-us/windows-hardware/drivers/usbcon/using-winusb-api-to-communicate-with-a-usb-device
#Get-PnpDevice -FriendlyName "STMicroelectronics 3-Axis Digital Accelerometer" | fl

function Get-FalcoXCOMPort(){
    param (
        [parameter(Mandatory=$false)][string]$viewThis
    )

    $script:comPort = [System.IO.Ports.SerialPort]::getportnames()

    if($viewThis){
        $comPort | ?{$_ -match $viewThis}
    }else{
        $comPort
    }
}
#Get-FalcoXCOMPort -viewThis COM7

function Get-FalcoXCOMPortDump(){
    param (
        [parameter(Mandatory=$true)][string]$comPort,
        [int]$Waitms
    )

    If(!$Waitms){$Waitms = 3000}
    $port = new-Object System.IO.Ports.SerialPort $comPort,115200,None,8,one
    $port.Open()
    start-sleep -Milliseconds 10
    $port.WriteLine("dump")
    start-sleep -Milliseconds $Waitms
    $Script:FalcoXDump = $port.ReadExisting()
    start-sleep -Milliseconds 250
    $port.Close()

    If(!$(($FalcoXDump -split "#")[1]) -match "OK"){
        Write-Host -ForegroundColor red "! Dump not complete, increase '-Waitms' !"
    }
    
    $FalcoXDump
}
#Get-FalcoXCOMPortDump -comPort COM7 -Waitms 3000

#Use this function to fetch all settings
function Get-FalcoXCOMPortReadLine(){
    param (
        [parameter(Mandatory=$true)][string]$comPort,
        [array]$inputString,
        [int]$Waitms
    )

    If(!$Waitms){$Waitms = 3000}
    #Only get command allowed
    If(($InputString -match "GET") -or ($InputString -match "version")){
        $port = new-Object System.IO.Ports.SerialPort $comPort,115200,None,8,one
        $port.Open()
        start-sleep -Milliseconds 10

        foreach($InputStringCommand in $inputString){
        
            $port.WriteLine("$($InputStringCommand)")
            start-sleep -Milliseconds 50
            $Script:readline = $port.ReadLine()
            start-sleep -Milliseconds 50
            #output one line
            $readline
        }

        #Save all lines to variable
        $Script:FalcoXDump = $port.ReadExisting()
        start-sleep -Milliseconds 50
        $port.Close()

    }
}
#Get-FalcoXCOMPortReadLine -comPort COM7 -Waitms 3000


function Set-FalcoXCOMPortWriteLine() {
    param (
        [parameter(Mandatory=$true)][string]$comPort,
        [array]$inputString
    )

    $port= new-Object System.IO.Ports.SerialPort $comPort,115200,None,8,one
    $port.open()
    start-sleep -Milliseconds 500

    foreach($InputStringCommand in $inputString){
        
        $port.WriteLine("$($InputStringCommand)")
        start-sleep -Milliseconds 100
        $readline = $port.ReadLine()
        start-sleep -Milliseconds 100
        #Check if input ok
        if(!($readline -match "#Ok")){
            $readline
            Write-Host "Could not set $($InputStringCommand)... :("            
        }else{
            Write-Host "$InputStringCommand - $readline"
        }  
    }

    #Save config
    start-sleep -Milliseconds 250
    $port.WriteLine("save")
        start-sleep -Milliseconds 250
        $readline = $port.ReadLine()
        start-sleep -Milliseconds 250
        #Check if input ok
        if(!($readline -match "#Ok")){
            $readline
            Write-Host "Could not save... :("
        }else{
            $readline
        }  
    start-sleep -Milliseconds 250
    $port.Close()
    
}
#Set-FalcoXCOMPortWriteLine -comPort COM7 -inputString "SET led_red=115","SET led_green=255","SET led_blue=245"


function Set-FalcoXCOMPortWriteDump() {
    param (
        [parameter(Mandatory=$true)][string]$comPort,
        [array]$inputString
    )

    $Percent = 100/$(($inputString).count)

    $port= new-Object System.IO.Ports.SerialPort $comPort,115200,None,8,one
    $port.open()
    start-sleep -Milliseconds 10

    foreach($inputString_ in $inputString){
        $Percent_ = $Percent_ + $Percent
        $Percent_Round = [math]::Round($Percent_,2) 
        Write-Progress -Activity "Restoring..." -Status "$Percent_Round% Complete:" -PercentComplete $Percent_Round;

        $port.WriteLine("$($inputString_)")
        start-sleep -Milliseconds 100
    }    

    #Save config
    $port.WriteLine("save")
        start-sleep -Milliseconds 1000
        $readline = $port.ReadLine()
        start-sleep -Milliseconds 10
        #Check if input ok
        if(!($readline -match "#Ok")){
            $readline
            Write-Host "Could not save... :("
        }else{
            $readline
        }  
    start-sleep -Milliseconds 250
    $port.Close()
    
}

########################

#Export pids,filters and rates from dump
function FalcoXPresetLookup{
    param (
        [parameter(Mandatory=$true)][string]$inputfile,
        [parameter(Mandatory=$true)][string]$OutputArrayName,
        [parameter(Mandatory=$true)][string]$Outputfile
    )

    $FalcoXPresetLookupArray = @("SET idle_percent","SET max_throttle","SET roll_p","SET roll_i","SET roll_d","SET pitch_p","SET pitch_i","SET pitch_d","SET yaw_p","SET yaw_i","SET yaw_d","SET level_kp","SET level_ki","SET level_angle","SET use_simmode","SET use_whisper","SET use_dyn_aa","SET aa_strength","SET d_term_aa_strength","SET p_curve0","SET p_curve1","SET p_curve2","SET p_curve3","SET p_curve4","SET p_curve5","SET p_curve6","SET p_curve7","SET p_curve8","SET p_curve9","SET p_curve10","SET i_curve0","SET i_curve1","SET i_curve2","SET i_curve3","SET i_curve4","SET i_curve5","SET i_curve6","SET i_curve7","SET i_curve8","SET i_curve9","SET i_curve10","SET d_curve0","SET d_curve1","SET d_curve2","SET d_curve3","SET d_curve4","SET d_curve5","SET d_curve6","SET d_curve7","SET d_curve8","SET d_curve9","SET d_curve10","SET cg_comp","SET sim_boost","SET smooth_stop","SET rc_smoothing_type","SET rc_smoothing_value","SET filt1_type","SET filt2_type","SET dfilt1_type","SET dfilt2_type","SET filt1_freq","SET filt2_freq","SET dfilt1_freq","SET dfilt2_freq","SET dyn_lpf_scale","SET pitch_rate1","SET roll_rate1","SET yaw_rate1","SET pitch_acrop1","SET roll_acrop1","SET yaw_acrop1","SET pitch_expo1","SET roll_expo1","SET yaw_expo1")

    $FalcoXAttributeArrayString = "$($OutputArrayName)" + ' = @('
    $FalcoXAttributeDUMPString = @()
    foreach($Attribute in $FalcoXPresetLookupArray){

        $AttributeLine = Get-content "$($inputfile)" | select-string -pattern "$($Attribute)" | ?{$_ -match "$($Attribute)"} | select -first 1
        $FalcoXAttributeArrayString += "'$($AttributeLine)', "
        #Textfile raw dump
        $FalcoXAttributeDUMPString += "$($AttributeLine)"
    }
    #Remove last comma
    $FalcoXAttributeArrayString = $FalcoXAttributeArrayString.Substring(0,$FalcoXAttributeArrayString.Length -2)
    $FalcoXAttributeArrayString += ')'
    $FalcoXAttributeArrayString | out-file "$($Outputfile)"
    $FalcoXAttributeDUMPString | out-file "$($Outputfile).dump"
}

#FalcoXPresetLookup -OutputArrayName '$Kimpa' -inputfile "c:\Users\teel\Downloads\kwadskwad6spids.txt" -Outputfile



########################

Function Get-VTXChannelMapping($SmartAudio){
    switch ($SmartAudio)
    {
        #Boscam A
        A1 { $VtxChannelMapping = 0; $VtxFreq = 5865 } #5865
        A2 { $VtxChannelMapping = 1; $VtxFreq = 5845 } #5845
        A3 { $VtxChannelMapping = 2; $VtxFreq = 5825 } #5825
        A4 { $VtxChannelMapping = 3; $VtxFreq = 5805 } #5805
        A5 { $VtxChannelMapping = 4; $VtxFreq = 5785 } #5785
        A6 { $VtxChannelMapping = 5; $VtxFreq = 5765 } #5765
        A7 { $VtxChannelMapping = 6; $VtxFreq = 5745 } #5745
        A8 { $VtxChannelMapping = 7; $VtxFreq = 5725 } #5725
        #Boscam B
        B1 { $VtxChannelMapping = 8; $VtxFreq = 5733 } #5733
        B2 { $VtxChannelMapping = 9; $VtxFreq = 5752 } #5752
        B3 { $VtxChannelMapping = 10; $VtxFreq = 5771 } #5771
        B4 { $VtxChannelMapping = 11; $VtxFreq = 5790 } #5790
        B5 { $VtxChannelMapping = 12; $VtxFreq = 5809 } #5809
        B6 { $VtxChannelMapping = 13; $VtxFreq = 5828 } #5828
        B7 { $VtxChannelMapping = 14; $VtxFreq = 5847 } #5847
        B8 { $VtxChannelMapping = 15; $VtxFreq = 5866 } #5866  
        #Boscam E
        E1 { $VtxChannelMapping = 16; $VtxFreq = 5705 } #5705
        E2 { $VtxChannelMapping = 17; $VtxFreq = 5685 } #5685
        E3 { $VtxChannelMapping = 18; $VtxFreq = 5665 } #5665
        E4 { $VtxChannelMapping = 19; $VtxFreq = 5645 } #5645
        E5 { $VtxChannelMapping = 20; $VtxFreq = 5885 } #5885
        E6 { $VtxChannelMapping = 21; $VtxFreq = 5905 } #5905
        E7 { $VtxChannelMapping = 22; $VtxFreq = 5925 } #5925
        E8 { $VtxChannelMapping = 23; $VtxFreq = 5945 } #5945  
        #Fatshark
        F1 { $VtxChannelMapping = 24; $VtxFreq = 5740 } #5740
        F2 { $VtxChannelMapping = 25; $VtxFreq = 5760 } #5760
        F3 { $VtxChannelMapping = 26; $VtxFreq = 5780 } #5780
        F4 { $VtxChannelMapping = 27; $VtxFreq = 5800 } #5800
        F5 { $VtxChannelMapping = 28; $VtxFreq = 5820 } #5820
        F6 { $VtxChannelMapping = 29; $VtxFreq = 5840 } #5840
        F7 { $VtxChannelMapping = 30; $VtxFreq = 5860 } #5860
        F8 { $VtxChannelMapping = 31; $VtxFreq = 5880 } #5880
        #Raceband R
        R1 { $VtxChannelMapping = 32; $VtxFreq = 5658 } #5658
        R2 { $VtxChannelMapping = 33; $VtxFreq = 5695 } #5695
        R3 { $VtxChannelMapping = 34; $VtxFreq = 5732 } #5732
        R4 { $VtxChannelMapping = 35; $VtxFreq = 5769 } #5769
        R5 { $VtxChannelMapping = 36; $VtxFreq = 5806 } #5806
        R6 { $VtxChannelMapping = 37; $VtxFreq = 5843 } #5843
        R7 { $VtxChannelMapping = 38; $VtxFreq = 5880 } #5880
        R8 { $VtxChannelMapping = 39; $VtxFreq = 5917 } #5917
        #IMD6
        IMD1 { $VtxChannelMapping = 40; $VtxFreq = 5732 } #5732
        IMD2 { $VtxChannelMapping = 41; $VtxFreq = 5765 } #5765
        IMD3 { $VtxChannelMapping = 42; $VtxFreq = 5828 } #5828
        IMD4 { $VtxChannelMapping = 43; $VtxFreq = 5840 } #5840
        IMD5 { $VtxChannelMapping = 44; $VtxFreq = 5866 } #5866
        IMD6 { $VtxChannelMapping = 45; $VtxFreq = 5740 } #5740
        IMD7 { $VtxChannelMapping = 46; $VtxFreq = "N/A" } #0
        IMD8 { $VtxChannelMapping = 47; $VtxFreq = "N/A" } #0
        #Boscam A
        0 { $VtxChannelMapping = "A1"; $VtxFreq = 5865 } #5865
        1 { $VtxChannelMapping = "A2"; $VtxFreq = 5845 } #5845
        2 { $VtxChannelMapping = "A3"; $VtxFreq = 5825 } #5825
        3 { $VtxChannelMapping = "A4"; $VtxFreq = 5805 } #5805
        4 { $VtxChannelMapping = "A5"; $VtxFreq = 5785 } #5785
        5 { $VtxChannelMapping = "A6"; $VtxFreq = 5765 } #5765
        6 { $VtxChannelMapping = "A7"; $VtxFreq = 5745 } #5745
        7 { $VtxChannelMapping = "A8"; $VtxFreq = 5725 } #5725
        #Boscam B
        8 { $VtxChannelMapping = "B1"; $VtxFreq = 5733 } #5733
        9 { $VtxChannelMapping = "B2"; $VtxFreq = 5752 } #5752
        10 { $VtxChannelMapping = "B3"; $VtxFreq = 5771 } #5771
        11 { $VtxChannelMapping = "B4"; $VtxFreq = 5790 } #5790
        12 { $VtxChannelMapping = "B5"; $VtxFreq = 5809 } #5809
        13 { $VtxChannelMapping = "B6"; $VtxFreq = 5828 } #5828
        14 { $VtxChannelMapping = "B7"; $VtxFreq = 5847 } #5847
        15 { $VtxChannelMapping = "B8"; $VtxFreq = 5866 } #5866  
        #Boscam E
        16 { $VtxChannelMapping = "E1"; $VtxFreq = 5705 } #5705
        17 { $VtxChannelMapping = "E2"; $VtxFreq = 5685 } #5685
        18 { $VtxChannelMapping = "E3"; $VtxFreq = 5665 } #5665
        19 { $VtxChannelMapping = "E4"; $VtxFreq = 5645 } #5645
        20 { $VtxChannelMapping = "E5"; $VtxFreq = 5885 } #5885
        21 { $VtxChannelMapping = "E6"; $VtxFreq = 5905 } #5905
        22 { $VtxChannelMapping = "E7"; $VtxFreq = 5925 } #5925
        23 { $VtxChannelMapping = "E8"; $VtxFreq = 5945 } #5945  
        #Fatshark
        24 { $VtxChannelMapping = "F1"; $VtxFreq = 5740 } #5740
        25 { $VtxChannelMapping = "F2"; $VtxFreq = 5760 } #5760
        26 { $VtxChannelMapping = "F3"; $VtxFreq = 5780 } #5780
        27 { $VtxChannelMapping = "F4"; $VtxFreq = 5800 } #5800
        28 { $VtxChannelMapping = "F5"; $VtxFreq = 5820 } #5820
        29 { $VtxChannelMapping = "F6"; $VtxFreq = 5840 } #5840
        30 { $VtxChannelMapping = "F7"; $VtxFreq = 5860 } #5860
        31 { $VtxChannelMapping = "F8"; $VtxFreq = 5880 } #5880
        #Raceband R
        32 { $VtxChannelMapping = "R1"; $VtxFreq = 5658 } #5658
        33 { $VtxChannelMapping = "R2"; $VtxFreq = 5695 } #5695
        34 { $VtxChannelMapping = "R3"; $VtxFreq = 5732 } #5732
        35 { $VtxChannelMapping = "R4"; $VtxFreq = 5769 } #5769
        36 { $VtxChannelMapping = "R5"; $VtxFreq = 5806 } #5806
        37 { $VtxChannelMapping = "R6"; $VtxFreq = 5843 } #5843
        38 { $VtxChannelMapping = "R7"; $VtxFreq = 5880 } #5880
        39 { $VtxChannelMapping = "R8"; $VtxFreq = 5917 } #5917
        #IMD6
        40 { $VtxChannelMapping = "IMD1"; $VtxFreq = 5732 } #5732
        41 { $VtxChannelMapping = "IMD2"; $VtxFreq = 5765 } #5765
        42 { $VtxChannelMapping = "IMD3"; $VtxFreq = 5828 } #5828
        43 { $VtxChannelMapping = "IMD4"; $VtxFreq = 5840 } #5840
        44 { $VtxChannelMapping = "IMD5"; $VtxFreq = 5866 } #5866
        45 { $VtxChannelMapping = "IMD6"; $VtxFreq = 5740 } #5740
        46 { $VtxChannelMapping = 46; $VtxFreq = "N/A" } #0
        47 { $VtxChannelMapping = 47; $VtxFreq = "N/A" } #0
    }
     
    $VtxChannelMapping
    $VtxFreq
}


Function Get-UARTMapping($protocol){
    switch ($protocol)
    {
       0 {$UARTMapping = "None"}
       1 {$UARTMapping = "SERIAL_TAG_SPEK2048"}
       2 {$UARTMapping = "SERIAL_TAG_CRSF"}
       3 {$UARTMapping = "SERIAL_TAG_SBUS"}
       4 {$UARTMapping = "SERIAL_TAG_FPORT"}
       5 {$UARTMapping = "SERIAL_TAG_INV_SBUS"}
       6 {$UARTMapping = "SERIAL_TAG_INV_FPORT"}
       7 {$UARTMapping = "SERIAL_TAG_SUMD"}
       8 {$UARTMapping = "SERIAL_TAG_IBUS"}
       9 {$UARTMapping = "SERIAL_TAG_SMART_AUDIO"}
       10 {$UARTMapping = "SERIAL_TAG_TRAMP_TELEM"}
       11 {$UARTMapping = "SERIAL_TAG_BLHELI_TELEM"}
       12 {$UARTMapping = "SERIAL_TAG_SRXL2"}
       13 {$UARTMapping = "SERIAL_TAG_DJI_SBUS"}
       14 {$UARTMapping = "SERIAL_TAG_MSP"}
       15 {$UARTMapping = "SERIAL_TAG_GPS"}
       16 {$UARTMapping = "SERIAL_TAG_FLX_LED"}
       None {$UARTMapping = 0}
       SPEK2048 {$UARTMapping = 1}
       CRSF {$UARTMapping = 2}
       SBUS {$UARTMapping = 3}
       FPORT {$UARTMapping = 4}
       INV_SBUS {$UARTMapping = 5}
       INV_FPORT {$UARTMapping = 6}
       SUMD {$UARTMapping = 7}
       IBUS {$UARTMapping = 8}
       SMART_AUDIO {$UARTMapping = 9}
       TRAMP_TELEM {$UARTMapping = 10}
       BLHELI_TELEM {$UARTMapping = 11}
       SRXL2 {$UARTMapping = 12}
       DJI_SBUS {$UARTMapping = 13}
       MSP {$UARTMapping = 14}
       GPS {$UARTMapping = 15}
       FLX_LED {$UARTMapping = 16}       
    }
     
    $UARTMapping
}
#Get-UARTMapping -protocol crsf




#####################################
GuidedMenu