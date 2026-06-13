#!/bin/bash

temp=$(awk '{print $1/1000}' /sys/class/thermal/thermal_zone0/temp)

mosquitto_pub \
-h 192.168.0.30 \
-u mqtt \
-P '9655514937' \
-r \
-t home/rpi5display/temperature \
-m "$temp"
