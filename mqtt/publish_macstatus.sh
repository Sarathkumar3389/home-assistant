#!/bin/bash
#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../" && pwd)"
CONFIG="$REPO_ROOT/config.json"
MQTT_SCRIPT="$REPO_ROOT/mqtt/mqtt_publish.sh"
DEVICE="macbook"

# MQTT Settings
MQTT_HOST=$(jq -r '.mqtt.host' "$CONFIG")
MQTT_PORT=$(jq -r '.mqtt.port' "$CONFIG")
MQTT_USER=$(jq -r '.mqtt.username' "$CONFIG")
MQTT_PASS=$(jq -r '.mqtt.password' "$CONFIG")

HOSTNAME=$(jq -r ".devices.${DEVICE}.hostname" "$CONFIG")
DEVICE_IP=$(jq -r ".devices.${DEVICE}.ip" "$CONFIG")

BAT=$(ls /sys/class/power_supply/ | grep BAT | head -n1)

[ -z "$BAT" ] && exit 1

CAPACITY=$(cat /sys/class/power_supply/$BAT/capacity)
"$MQTT_SCRIPT" "home/$HOSTNAME/battery/capacity" "$CAPACITY"