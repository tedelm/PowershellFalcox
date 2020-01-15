#https://docs.microsoft.com/en-us/windows-hardware/drivers/usbcon/developing-windows-applications-that-communicate-with-a-usb-device
#https://docs.microsoft.com/en-us/windows-hardware/drivers/usbcon/using-winusb-api-to-communicate-with-a-usb-device
#Get-PnpDevice -FriendlyName "STMicroelectronics 3-Axis Digital Accelerometer" | fl

function Get-ComPorts($viewThis){
    $script:comPort = [System.IO.Ports.SerialPort]::getportnames()

    if($viewThis){
        $comPort | ?{$_ -match $viewThis}
    }else{
        $comPort
    }
}
#Get-ComPorts
#Get-ComPorts -viewThis COM3


function Get-ComPortData($comPort,$ComSpeed,$comDataBits,$comStopBits){
    #$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one
    $port= new-Object System.IO.Ports.SerialPort $comPort,$ComSpeed,None,$comDataBits,$comStopBits
    $port.Open()
    $port.ReadLine()
    $port.Close()
}
#Get-ComPortData -comPort COM3 -ComSpeed 9600 -comDataBits 8 -comStopBits one

function Set-ComPortData($comPort,$ComSpeed,$comDataBits,$comStopBits,$inputString) {
    #$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one
    $port= new-Object System.IO.Ports.SerialPort $comPort,$ComSpeed,None,$comDataBits,$comStopBits
    $port.open()
    $port.WriteLine("$($inputString)")
    $port.Close()
    
}
#Set-ComPortData -comPort COM3 -ComSpeed 9600 -comDataBits 8 -comStopBits one -inputString "Hello World"

Export-ModuleMember -Function Get-ComPorts
Export-ModuleMember -Function Get-ComPortData
Export-ModuleMember -Function Set-ComPortData


$port= new-Object System.IO.Ports.SerialPort "COM1",9600,None,8,one
$port.Open()
$port.ReadLine()
$port.Close()
}