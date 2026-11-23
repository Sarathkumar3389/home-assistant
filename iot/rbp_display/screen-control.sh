#!/bin/bash

BACKLIGHT_PATH="/sys/class/backlight/10-0045"
MAX_BRIGHTNESS=$(<"$BACKLIGHT_PATH/max_brightness")
HALF_BRIGHTNESS=$((MAX_BRIGHTNESS / 2))
BRIGHTNESS_OFF=0

TOUCH_DEVICE=$(awk '
    BEGIN { found=0 }
    /Goodix Capacitive TouchScreen/ { found=1 }
    found && /Handlers/ {
        for (i=1; i<=NF; i++) {
            if ($i ~ /^event[0-9]+$/) {
                print $i
                exit
            }
        }
    }
' /proc/bus/input/devices)

TOUCH_DEVICE="/dev/input/$TOUCH_DEVICE"
echo "Using touch device: $TOUCH_DEVICE"
# TIMEOUT=20
TIMEOUT_DIM=10
CURRENT1=$MAX_BRIGHTNESS
dimming=false

set_brightness() {
    echo "$1" | sudo tee "$BACKLIGHT_PATH/brightness" > /dev/null
}

if [ ! -c "$TOUCH_DEVICE" ]; then
    echo "Touch device $TOUCH_DEVICE not found!"
    exit 1
fi

last_touch_time=$(date +%s)
screen_on=true

# FIFO for events
fifo="/tmp/touch_events_fifo"
rm -f "$fifo"
mkfifo "$fifo"

# Start evtest in background writing to FIFO
sudo evtest "$TOUCH_DEVICE" 2>/dev/null |
grep --line-buffered -E "type +1 \(EV_KEY\), code +330 \(BTN_TOUCH\), value +1$" > "$fifo" &

# Open FIFO for reading in a persistent FD
exec 3<"$fifo"

while true; do
    if read -t 0.1 _ <&3; then
        echo "Touch detected"
        last_touch_time=$(date +%s)
        if [[ "$screen_on" != true || "$dimming" == true ]]; then
            echo "Turning brightness ON"
            set_brightness "$MAX_BRIGHTNESS"
            screen_on=true
            dimming=false
            CURRENT1=$MAX_BRIGHTNESS
        fi
    fi

    if $screen_on; then
        now=$(date +%s)
        diff=$(( now - last_touch_time ))
        echo "Idle time: $diff seconds (screen_on=$screen_on)"
        
        if (( diff >= TIMEOUT_DIM )); then
            echo "Timeout reached: Dimming"
            dimming=true
            echo "$CURRENT1"
            CURRENT1=$((CURRENT1 - 1))
            if [ "$CURRENT1" -eq 22 ]; then
                CURRENT1=20
            fi
            if [ "$CURRENT1" -eq 14 ]; then
                CURRENT1=12
            fi
            if [ "$CURRENT1" -eq 11 ]; then
                screen_on=false
                dimming=false
                CURRENT1=$BRIGHTNESS_OFF
            fi
            set_brightness "$CURRENT1"
        fi

        if ((CURRENT1==$BRIGHTNESS_OFF)); then
            screen_on=false
            dimming=false
            CURRENT1=$BRIGHTNESS_OFF
        fi
        # if (( diff >= TIMEOUT )); then
        #     echo "Timeout reached: turning brightness OFF"
        #     set_brightness "$BRIGHTNESS_OFF"
        #     screen_on=false
        # fi
    fi

    sleep 1
done
