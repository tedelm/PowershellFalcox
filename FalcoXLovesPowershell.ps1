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
2020-01-14: Added ComPort module for read/write to comport

.EXAMPLE
. .\FalcoXLovesPowershell.ps1
GetFalcoX -InputFile "C:\Users\TEEL\Google Drive\Drone\MiniSquad\FalcoX Tunes\miniSquad_4inch_4s_falcoX_Alpha_v0.10.txt" -ViewThis pid,filter,rates,tpa

.LINK
https://github.com/tedelm/PowershellFalcox

#>

#Import Modules
Import-Module '.\comPort.psm1' #Module to read/write to comport

Function GetFalcoX($InputFile,$ViewThis){

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
    $content_clean = $content -split "," -replace "SET ","" -replace '"',''

    If($ViewThis -match "pid"){
        Write-Host "-- PIDs ---"
        Write-Host " "
        $PIDS = $content_clean | select-string -pattern "roll_([\w])=","pitch_([\w])=","yaw_([\w])="
        $RollDtermPercent = [int]$($(100/$($($PIDS[0] -split "=")[1])) * $(($PIDS[2] -split "=")[1]))
        $PitchDtermPercent = [int]$($(100/$($($PIDS[3] -split "=")[1])) * $(($PIDS[5] -split "=")[1]))
        $YawDtermPercent = [int]$($(100/$($($PIDS[6] -split "=")[1])) * $(($PIDS[8] -split "=")[1]))

        Write-host "Roll: $($($PIDS[0] -split "=")[1]), $($($PIDS[1] -split "=")[1]), $($($PIDS[2] -split "=")[1]) -- D-term: $RollDtermPercent%"
        Write-host "Pitch: $($($PIDS[3] -split "=")[1]), $($($PIDS[4] -split "=")[1]), $($($PIDS[5] -split "=")[1]) -- D-term: $PitchDtermPercent%"
        Write-host "Yaw: $($($PIDS[6] -split "=")[1]), $($($PIDS[7] -split "=")[1]), $($($PIDS[8] -split "=")[1]) -- D-term: $YawDtermPercent%"
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
            Write-Host " "
    }

    If($ViewThis -match "rates"){
        Write-Host "-- Rates ---"
        $Rates = $content_clean | select-string -pattern "roll_rate([\d])=","pitch_rate([\d])=","yaw_rate([\d])=","roll_acrop([\d])=","pitch_acrop([\d])=","yaw_acrop([\d])=","roll_expo([\d])=","pitch_expo([\d])=","yaw_expo([\d])=","rate_"
        Write-host "----- RATE, ACRO, EXPO -----"
        Write-host "Roll: $($($Rates[0] -split "=")[1]), $($($Rates[3] -split "=")[1]), $($($Rates[6] -split "=")[1])"
        Write-host "Pitch: $($($Rates[1] -split "=")[1]), $($($Rates[4] -split "=")[1]), $($($Rates[7] -split "=")[1])"
        Write-host "Yaw: $($($Rates[2] -split "=")[1]), $($($Rates[5] -split "=")[1]), $($($Rates[8] -split "=")[1])"        
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


GetFalcoX -InputFile "C:\Users\TEEL\Google Drive\Drone\MiniSquad\FalcoX Tunes\miniSquad_4inch_4s_falcoX_Alpha_v0.10.txt" -ViewThis pid,filter,rates,tpa