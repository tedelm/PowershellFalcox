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

.EXAMPLE
. .\FalcoXLovesPowershell.ps1
GetFalcoX -InputFile ".\miniSquad_4inch_4s_falcoX_Alpha_v0.10.txt" -ViewThis pid,filter,rates,tpa

.LINK
https://github.com/tedelm/PowershellFalcox

#>

#Import Modules
#Import-Module '.\comPort.psm1' #Module to read/write to comport

#Main function for GET
Function Get-FalcoXConfig($InputFile,$ViewThis){

    #Get filter names
    Function FilterNumb($Filterint){
        switch ($Filterint)
        {
            1 { $result = 'BiQuad' }
            2 { $result = 'Frequency' }
            3 { $result = 'Dynamic' }
        }
    
        $result
    }

    #clear
    $content = Get-Content $InputFile
    $content_clean = $content -split "," -replace "SET ","" -replace '"','' -replace "\[" -replace "\]"
    
    #Parse file
    $FalcoXTable = New-Object PSObject
    Foreach($contentLine in $content_clean){
        $FalcoXTable | Add-Member NoteProperty -Name "$($($contentLine -split '=')[0])" -Value "$($($contentLine -split '=')[1])" -ErrorAction silentlycontinue
    }

    If($ViewThis -match "pids"){
        $PIDs_table = $FalcoXTable | select "roll_p","roll_i","roll_d","pitch_p","pitch_i","pitch_d","yaw_p","yaw_i","yaw_d"
        
        Write-host "Roll: $($PIDs_table.roll_p),$($PIDs_table.roll_i),$($PIDs_table.roll_d)"
        Write-host "Pitch: $($PIDs_table.pitch_p),$($PIDs_table.pitch_i),$($PIDs_table.pitch_d)"
        Write-host "Yaw: $($PIDs_table.yaw_p),$($PIDs_table.yaw_i),$($PIDs_table.yaw_d)"
    }

    If($ViewThis -match "stringPid"){
        Write-Host "-- PIDs ---"
        $PIDS = $content_clean | select-string -pattern "roll_([\w])=","pitch_([\w])=","yaw_([\w])="
        $RollDtermPercent = [int]$($(100/$($($PIDS[0] -split "=")[1])) * $(($PIDS[2] -split "=")[1]))
        $PitchDtermPercent = [int]$($(100/$($($PIDS[3] -split "=")[1])) * $(($PIDS[5] -split "=")[1]))
        $YawDtermPercent = [int]$($(100/$($($PIDS[6] -split "=")[1])) * $(($PIDS[8] -split "=")[1]))

        Write-host "Roll: $($($PIDS[0] -split "=")[1]), $($($PIDS[1] -split "=")[1]), $($($PIDS[2] -split "=")[1]) -- D-term: $RollDtermPercent%"
        Write-host "Pitch: $($($PIDS[3] -split "=")[1]), $($($PIDS[4] -split "=")[1]), $($($PIDS[5] -split "=")[1]) -- D-term: $PitchDtermPercent%"
        Write-host "Yaw: $($($PIDS[6] -split "=")[1]), $($($PIDS[7] -split "=")[1]), $($($PIDS[8] -split "=")[1]) -- D-term: $YawDtermPercent%"
        Write-Host " " 
        Write-Host "-- Misc ---"
        $PIDS_misc = $content_clean | select-string -pattern "use_simmode=","sim_boost=","use_whisper=","cg_comp="
            If($($($PIDS_misc[0] -split "=")[1]) -match "1"){$SIMmodeEnabled = "True"}else{$SIMmodeEnabled = "False"}
            If($($($PIDS_misc[1] -split "=")[1]) -match "1"){$WhisperEnabled = "True"}else{$WhisperEnabled = "False"}
        Write-host "SIM Mode Enabled: $SIMmodeEnabled"
        Write-host "SIM Boost: $($($PIDS_misc[3] -split "=")[1])"
        Write-host "Whisper Enabled: $WhisperEnabled"
        Write-host "CG: $($($PIDS_misc[2] -split "=")[1])"
        
        Write-Host " "

    }

    If($ViewThis -match "filter"){
        Write-Host "-- Filters ---"
        $filters = $content_clean | select-string -pattern "filt([\d])","dynLpfScale="
        
            Write-Host "----- Gyro -----"
            Write-Host "Filter1: $(FilterNumb -Filterint $(($filters[0]) -split '=','')[1]), @ $($($filters[4] -split "=")[1]) Hz"
            Write-Host "Filter2: $(FilterNumb -Filterint $(($filters[1]) -split '=','')[1]), @ $($($filters[5] -split "=")[1]) Hz"
            Write-Host "Dynamic filter Strenght: $($($filters[8] -split '=')[1])"

            Write-Host "----- D-Term -----"
            Write-Host "Filter1: $(FilterNumb -Filterint $(($filters[2]) -split '=','')[1]), @ $($($filters[6] -split "=")[1]) Hz"
            Write-Host "Filter2: $(FilterNumb -Filterint $(($filters[3]) -split '=','')[1]), @ $($($filters[7] -split "=")[1]) Hz"  

            Write-Host "-- Dynamic AA ---"
            $filters_aa = $content_clean | select-string -pattern "use_dyn_aa=","aa_strength="
                If($($($filters_aa[0] -split "=")[1]) -match "1"){$DynamicAAEnabled = "True"}else{$DynamicAAEnabled = "False"}
            Write-Host "Dynamic AA Enabled: $DynamicAAEnabled"
            Write-Host "Dynamic AA Strength: $($($filters_aa[1] -split "=")[1])"
            Write-Host " "
    }

    If($ViewThis -match "rates"){
        Write-Host "-- Rates ---"
        $Rates = $content_clean | select-string -pattern "roll_rate([\d])=","pitch_rate([\d])=","yaw_rate([\d])=","roll_acrop([\d])=","pitch_acrop([\d])=","yaw_acrop([\d])=","roll_expo([\d])=","pitch_expo([\d])=","yaw_expo([\d])=","rate_"
        Write-host "----- RATE, ACRO, EXPO -----"
        Write-host "Roll: $($($Rates[0] -split "=")[1]), $($($Rates[3] -split "=")[1]), $($($Rates[6] -split "=")[1])"
        Write-host "Pitch: $($($Rates[1] -split "=")[1]), $($($Rates[4] -split "=")[1]), $($($Rates[7] -split "=")[1])"
        Write-host "Yaw: $($($Rates[2] -split "=")[1]), $($($Rates[5] -split "=")[1]), $($($Rates[8] -split "=")[1])"    
        Write-host "----- RC Smooth -----"
        $Rates_Smooth = $content_clean | select-string -pattern "rc_smoothing_type=","rc_smoothing_value="
        Write-host "RC Smooth type: $($($Rates_Smooth[0] -split "=")[1])"
        Write-host "RC Smooth: $($($Rates_Smooth[1] -split "=")[1])"

        Write-Host " "
    }

    If($ViewThis -match "tpa"){
        Write-Host "-- TPA ---"
        $TPA = $content_clean | select-string -pattern "([\w])_curve([\d])="

        $TPA_P = $($TPA[0..9]) -replace "([\w])_curve([\d])=",""
        $TPA_I = $($TPA[10..19]) -replace "([\w])_curve([\d])=",""
        $TPA_D = $($TPA[20..29]) -replace "([\w])_curve([\d])=",""

        Write-host "Throttle: 0-100%"
        Write-host "P: $TPA_P"
        Write-host "I: $TPA_I"
        Write-host "D: $TPA_D"
    }

     If($ViewThis -match "all"){
        $content_clean
    }   
    

}









