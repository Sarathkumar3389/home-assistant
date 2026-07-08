#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
MQTT_SCRIPT="$REPO_ROOT/ha/mqtt_publish.sh"

DEVICE="rpi5display"
TEMP=$(awk '{printf "%.1f", $1/1000}' /sys/class/thermal/thermal_zone0/temp)

"$MQTT_SCRIPT" "home/${DEVICE}/temperature" "$TEMP"