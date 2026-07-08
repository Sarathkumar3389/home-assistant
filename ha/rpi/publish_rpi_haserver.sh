#!/bin/bash

DEVICE="rpi5haserver"
TEMP=$(awk '{printf "%.1f", $1/1000}' /sys/class/thermal/thermal_zone0/temp)

"$MQTT_SCRIPT" "home/${DEVICE}/temperature" "$TEMP"