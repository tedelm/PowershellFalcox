#https://docs.microsoft.com/en-us/windows-hardware/drivers/usbcon/developing-windows-applications-that-communicate-with-a-usb-device
#https://docs.microsoft.com/en-us/windows-hardware/drivers/usbcon/using-winusb-api-to-communicate-with-a-usb-device
#Get-PnpDevice -FriendlyName "STMicroelectronics 3-Axis Digital Accelerometer" | fl

function Get-FalcoXCOMPort($viewThis){
    $script:comPort = [System.IO.Ports.SerialPort]::getportnames()

    if($viewThis){
        $comPort | ?{$_ -match $viewThis}
    }else{
        $comPort
    }
}
#Get-FalcoXCOMPort -viewThis COM7

function Get-FalcoXCOMPortDump($comPort, [int]$Waitms){

    If(!$Waitms){$Waitms = 3000}
    
    $port = new-Object System.IO.Ports.SerialPort $comPort,9600,None,8,one
    $port.Open()
    start-sleep -Milliseconds 500
    $port.WriteLine("dump")
    start-sleep -Milliseconds $Waitms
    $Script:FalcoXDump = $port.ReadExisting()
    start-sleep -Milliseconds 250
    $port.Close()

    If(!$(($FalcoXDump -split "#")[1]) -match "OK"){
        Write-Host -ForegroundColor red "! Dump not complete, increase '-Waitms' !"
    }
}
#Get-FalcoXCOMPortDump -comPort COM7 -Waitms 3000

function Set-FalcoXCOMPortConfig($comPort,$ComSpeed,$comDataBits,$comStopBits,$inputString) {
    
    $port= new-Object System.IO.Ports.SerialPort $comPort,9600,None,8,one
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
#Set-FalcoXCOMPortConfig -comPort COM7 -inputString "SET led_red=115","SET led_green=255","SET led_blue=245"

Export-ModuleMember -Function Get-FalcoXCOMPort
Export-ModuleMember -Function Get-FalcoXCOMPortDump
Export-ModuleMember -Function Set-FalcoXCOMPortConfig
