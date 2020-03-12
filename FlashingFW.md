#Flashing firmware</br>
</br>
From 1.2.xx (or older) to FalcoX</br>
</br>
</br>
Install latest Beta Configurator:
</br>
https://flightone.com/download.php?version=beta
</br>
put FC in DFU Bootloader mode (STM32 Bootloader, not "FlightOne Bootloader") by shorting Boot pins (use solder tinn)
</br>
You can check under "Device Manager"->"View"->"Devices by container" which bootloader is being used.
</br>
flash Beta Firmware to FC and disconnect FC.
</br>
with boot pins still connected
</br>
Download and install latest Alpha Configurator, https://flightone.com/download.php?version=alpha
</br>
flash Alpha Firmware to FC and disconnect FC.
</br>
remove solder tinn from boot pins
