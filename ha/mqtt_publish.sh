#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG="$REPO_ROOT/config.json"

MQTT_HOST=$(jq -r '.mqtt.host' "$CONFIG")
MQTT_PORT=$(jq -r '.mqtt.port' "$CONFIG")
MQTT_USER=$(jq -r '.mqtt.username' "$CONFIG")
MQTT_PASS=$(jq -r '.mqtt.password' "$CONFIG")

TOPIC="$1"
VALUE="$2"

mosquitto_pub \
    -h "$MQTT_HOST" \
    -p "$MQTT_PORT" \
    -u "$MQTT_USER" \
    -P "$MQTT_PASS" \
    -r \
    -t "$TOPIC" \
    -m "$VALUE"