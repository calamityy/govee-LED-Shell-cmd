# govee-LED-Shell-cmd
A simple shell script allowing communication to a Govee LED strip via [BLE](https://en.wikipedia.org/wiki/Bluetooth_Low_Energy).  
An effort has been made to include as much detailed usage documentation to make this more beginner-friendly.  

#### DISCLAIMER: This is for educational purposes only. By using this resource, you acknowledge that neither me nor any repository contributors are responsible for any possible damage caused by using this resource. Use at your own risk.  
### Features:
- on/off
- colour (RGB in hex)
- brightness (percentage of 255)
- preset colours

## Devices with known support
Successfully run on `Raspbian GNU/Linux 9 (stretch)`, version `5.10.63+`, on a `Raspberry Pi Zero W`.  
Device(s) successfully used: `H6139`.\
If this script works with a different device or OS, let me know via one of the contact methods in [Support](https://github.com/calamityy/govee-LED-Shell-cmd#support).

# Installation
Simply navigate to your chosen directory, and run
```bash
git clone https://github.com/calamityy/govee-LED-Shell-cmd.git /path/to/your/chosen/directory
```
 
You _may_ need to install BlueZ and gatttool for this to work.


# Getting started
#### Starting your bluetooth adapter
Enable bluetooth adapter
```bash
sudo hciconfig hci0 up
```
Ensure bluetooth adapter is running
```bash
hcitool dev
```
it should read something similar to:
```bash
Devices:
        hci0    00:1A:C2:7B:00:47
```
#### Finding the MAC address of your LEDs
Enable the bluetooth controller prompt
```bash
bluetoothctl
```
In the prompt, scan for devices
```bash
scan on
```
wait a few seconds, then turn off the scan
```bash
scan off
```
Bluetooth devices found should be displayed, Govee LED strips look similar to
```bash
[NEW] Device 00:1A:C2:7B:00:47 ihoment_H6139_6179
```
The code before `ihoment_H6139_6179` is your MAC address. Enter it at the top of `led.sh`- there'll be a variable called MAC.

#### Allowing the shell script to be executed
You'll also need to allow the shell file to be executed. To do this, navigate to the directory it's in, and run
```bash
chmod +x led.sh
```
That's it, you're ready to go!
# Usage
_Note: These examples require you to be in the directory containing the `led.sh` file. You can run the script from anywhere by adding the path, for example from the home directory:`./govee-LED-Shell-cmd/led.sh [parameter(s)]`_
#### On/Off
```bash
./led.sh [on/off]

./led.sh on #on
./led.sh off #off
```
#### Colour
```bash
./led.sh colour [r] [g] [b]

./led.sh colour ff 00 ff  #changes to purple
./led.sh colour d9 14 00  #changes to dark orange
```
#### Brightness
```bash
./led.sh br [% of 255]

./led.sh br 30 #30% brightness
./led.sh br 80 #80% brightness
```
#### Preset Colours
Current preset colours: red, orange, burnt_orange, yellow, turquoise, green, blue, purple, and pink.
```bash
./led.sh [preset name]

./led.sh red #changes to red
./led.sh pink #changes to pink
```
## To-Do
- Combine colour and brightness into 1 command
- Fade/breathing between colours
- Return current status (on/off, brightness, colour)/listen to keepalive
- Reproduce this in python ```In progress```

## Sources
https://github.com/chvolkmann/govee_btled  
https://github.com/philhzss/Govee-H6127-Reverse-Engineering  
https://github.com/jurassic-marc/govee-h6159-light-strip-reverse-engineer  
https://github.com/BeauJBurroughs/Govee-H6127-Reverse-Engineering

## Support
I'm a beginner to shell/bash, so any contributions are greatly appreciated!  
If you wish to contribute to this respository: Make a pull request.  
Have a suggestion, question or problem? Make an [issue](https://github.com/calamityy/govee-LED-Shell-cmd/issues) and I'll get back to you ASAP!  
