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
