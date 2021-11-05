#!/bin/bash

# Govee LED Toolkit v1.0
# Please see LICENSE for distribution info.
MAC="INSERT_MAC_HERE_WITHIN_DOUBLE_QUOTES"

# Turns LED strip on.
# Usage:
#           ./led.sh on
if [ "$1" == "on" ]; then
    gatttool -b $MAC --char-write-req --handle 0x0015 --value 3301010000000000000000000000000000000033 > /dev/null
    echo "Govee LED Toolkit v1.0"
    echo "Turned LED strip on. Use './led.sh off' to turn off."

# Turns LED strip off. DOES NOT set brightness to 0.
# Usage:
#           ./led.sh off
elif [ "$1" == "off" ]; then
    gatttool -b $MAC --char-write-req --handle 0x0015 --value 3301000000000000000000000000000000000032 > /dev/null
    echo "Govee LED Toolkit v1.0"
    echo "Turned LED strip off. Use './led.sh on' to turn on."

# Set brightness to a percentage of 255 (0-100).
# NOTE: Any percentage below 7 causes some LEDs to turn on, but not others; an inaccurate colour may be produced.
# Usage:
#           ./led.sh 25
#           ./led.sh 64
elif [ "$1" == "br" ]; then
    decimal=$(awk -v percent=$2 'BEGIN{printf("%.2f\n",percent/100)}') # Convert percentage to decimal/fraction
    hex_percent=$(awk -v decimal=$decimal 'BEGIN{printf("%x",255*decimal-1)}') # Calculate percentage of 255 using decimal, print as hex
    if (( "$2" <= "6" )); then # Adds zero onto anything below decimal value of 16 (i.e: <= 0f) (~6% of 255 is 16, and it uses the percentage input) to allow it to be used. Would otherwise produce values such as 'e' or '4' instead of '0e' and '04'.
        hex_percent="0${hex_percent}"
    fi
    check=$(printf '%x' $(( 0x33 ^ 0x04 ^ 16#$hex_percent ))) # XOR checksum calculation
    wait
    code=$(echo 3304${hex_percent}00000000000000000000000000000000${check}) # Zeros were being truncated for some reason; put code in separate variable to fix this
    gatttool -b $MAC --char-write-req --handle 0x0015 --value $code > /dev/null #main gatttool command
    
# Changes colour to specfied RGB values.
# Usage:
#           ./led.sh colour <r> <g> <b>
# Examples:
#           .led.sh colour 00 ff 00
#           .led.sh colour d9 14 00
elif [ "$1" == "colour" ]; then
    check=$(printf '%x' $(( 0x33 ^ 0x05 ^ 0x02 ^ 16#$2 ^ 16#$3 ^ 16#$4 ))) #XOR checksum calculation
    wait # was to prevent hci0 problems, might remove
    gatttool -b $MAC --char-write-req --handle 0x0015 --value 330502$2$3$400000000000000000000000000$check > /dev/null #main gatttool command
    echo "Changed colour to #"$2$3$4

# Changes colour to a preset.
# Available presets are: red, orange, burnt_orange, yellow, turquoise, green, blue, purple, and pink.
# Usage:
#           ./led.sh [preset]
# Examples:
#           ./led.sh red
#           ./led.sh purple
elif [ "$1" == "red" ];then
    gatttool -b $MAC --char-write-req --handle 0x0015 --value 330502FF000000000000000000000000000000CB > /dev/null
    echo "Changed colour to "$1
elif [ "$1" == "orange" ];then
    gatttool -b $MAC --char-write-req --handle 0x0015 --value 330502ff750000ff8912000000000000000000da > /dev/null
    echo "Changed colour to "$1
elif [ "$1" == "burnt_orange" ];then
    gatttool -b $MAC --char-write-req --handle 0x0015 --value 330502d9140000000000000000000000000000f9 > /dev/null
    echo "Changed colour to "$1
elif [ "$1" == "yellow" ];then
    gatttool -b $MAC --char-write-req --handle 0x0015 --value 330502ffff0000ff891200000000000000000050 > /dev/null
    echo "Changed colour to "$1
elif [ "$1" == "turq" ];then
    gatttool -b $MAC --char-write-req --handle 0x0015 --value 33050200ffff00ff891200000000000000000050 > /dev/null
    echo "Changed colour to "$1
elif [ "$1" == "green" ];then
    gatttool -b $MAC --char-write-req --handle 0x0015 --value 33050200FF0000000000000000000000000000CB > /dev/null
    echo "Changed colour to "$1
elif [ "$1" == "blue" ];then
    gatttool -b $MAC --char-write-req --handle 0x0015 --value 3305020000FF00000000000000000000000000CB > /dev/null
    echo "Changed colour to "$1
elif [ "$1" == "purple" ];then
    gatttool -b $MAC --char-write-req --handle 0x0015 --value 3305027500ff00ff8912000000000000000000da > /dev/null
    echo "Changed colour to "$1
elif [ "$1" == "pink" ];then
    gatttool -b $MAC --char-write-req --handle 0x0015 --value 330502ff00e300ff89120000000000000000004c > /dev/null
    echo "Changed colour to "$1
else echo "Error: no valid option selected"
fi