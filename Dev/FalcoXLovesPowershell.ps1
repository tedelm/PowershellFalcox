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
. .\FalcoXLovesPowershell.ps1
GetFalcoX -InputFile ".\miniSquad_4inch_4s_falcoX_Alpha_v0.10.txt" -ViewThis pid,filter,rates,tpa

.LINK
https://github.com/tedelm/PowershellFalcox

#>

#Import Modules
Import-Module '.\comPort.psm1' #Module to read/write to comport
Import-Module '.\vtxchannelmap.psm1' #Module for vtx channel mapping, Smart Audio/IRC Tramp


####
####
# Main function for getting config from FC
####
####
Function Get-FalcoXConfig {
    param (
        [parameter(Mandatory=$true)][string]$comPort,
        [int]$Waitms,
        [switch]$VtxChannel
        #[switch]$PilotName
        #[switch]$LedColor
    )

    If($VtxChannel){
        Write-Host "VTX Settings:"
        $VtxChannelRaw = Get-FalcoXCOMPortReadLine -comPort $comPort -InputString "GET vtx_channel"
        $VtxChannelRaw = $VtxChannelRaw -split "="
        $VtxChannelRaw = [int]$($VtxChannelRaw[1])
        $VTXSettings = Get-VTXChannelMapping -SmartAudio $VtxChannelRaw
        "$($VTXSettings[0]) - $($VTXSettings[1])" | Out-Host

    }
    
}
####
####
#Main function for Seting config directly to FC
####
####
Function Set-FalcoXConfig {
    param (
        [switch]$VtxChannel,
        [switch]$PilotName,
        [switch]$LedColor
    )

    If($VtxChannel){
        Write-Host "Setting vtx"
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
        [switch]$Pilotname
    )

    $InputFile
    $InputFile_clean = (Get-Content $InputFile) -split "," -replace "SET ","" -replace '"','' -replace "\[" -replace "\]"
    
    #Output raw config to screen
    If($RawConfig){$InputFile_clean}

    #Parse file
    $FalcoXTable = New-Object PSObject
    Foreach($contentLine in $InputFile_clean){$FalcoXTable | Add-Member NoteProperty -Name "$($($contentLine -split '=')[0])" -Value "$($($contentLine -split '=')[1])" -ErrorAction silentlycontinue}

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
        $Filters_tbl = $FalcoXTable | select "filt1_type","filt1_freq","filt2_type","filt2_freq","dfilt1_type","dfilt1_freq","dfilt2_freq","dynLpfScale","use_dyn_aa","aa_strength"
        
        Write-Host "----- Gyro -----"
        Write-Host "Filter1: $(FilterNumb -Filterint $($Filters_tbl.filt1_type)) @ $($Filters_tbl.filt1_freq) Hz"
        Write-Host "Filter2: $(FilterNumb -Filterint $($Filters_tbl.filt2_type)) @ $($Filters_tbl.filt2_freq) Hz"
        Write-Host "Dynamic filter Strenght: $($Filters_tbl.dynLpfScale)"

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