#!/bin/bash
# Wait until network is online
while ! ping -c1 homeassistant.local &>/dev/null; do sleep 1; done

# Start X with unclutter and Chromium in kiosk mode
xset s off         # Disable screen saver
xset -dpms         # Disable DPMS power management
xset s noblank     # Don't blank the screen

unclutter -idle 0 &

chromium-browser --noerrdialogs --disable-infobars --kiosk http://homeassistant.local:8123
