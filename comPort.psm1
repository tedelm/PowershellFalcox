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

function Set-FalcoXCOMPortFunctions(){
    param (
        [parameter(Mandatory=$true)][string]$comPort,
        [string]$inputString,
        [int]$Waitms
    )

    If(!$Waitms){$Waitms = 250}
    $port = new-Object System.IO.Ports.SerialPort $comPort,115200,None,8,one
    $port.Open()
    start-sleep -Milliseconds 10
    $port.WriteLine("$($inputString)")
    start-sleep -Milliseconds $Waitms
    #$Script:FalcoXDump = $port.ReadExisting()
    start-sleep -Milliseconds 250
    $port.Close()

    #If(!$(($FalcoXDump -split "#")[1]) -match "OK"){
    #    Write-Host -ForegroundColor red "! Error, try '-Waitms 3000' !"
    #}
    
    #$FalcoXDump
}
#Get-FalcoXCOMPortFunctions -comPort COM7 -Waitms 3000 -inputString


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
        start-sleep -Milliseconds 500
        $readline = $port.ReadLine()
        start-sleep -Milliseconds 250
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


Export-ModuleMember -Function Get-FalcoXCOMPort
Export-ModuleMember -Function Get-FalcoXCOMPortDump
Export-ModuleMember -Function Get-FalcoXCOMPortReadLine
Export-ModuleMember -Function Set-FalcoXCOMPortWriteLine
Export-ModuleMember -Function Set-FalcoXCOMPortWriteDump
Export-ModuleMember -Function Set-FalcoXCOMPortFunctions



