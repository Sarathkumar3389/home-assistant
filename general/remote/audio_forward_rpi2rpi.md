## Receiver RPi
### Configuration
mkdir -p ~/.config/pipewire/pipewire-pulse.conf.d

nano ~/.config/pipewire/pipewire-pulse.conf.d/50-network.conf

pulse.properties = {
    server.address = [
        "unix:native"
        "tcp:4713"
    ]
}

### Verify 
systemctl --user restart pipewire-pulse.service
pactl info
ss -ltn | grep 4713

Expected:
LISTEN 0      32           0.0.0.0:4713      0.0.0.0:*          
LISTEN 0      32              [::]:4713         [::]:* 

## Sender RPI
### Test Conncetion from 
nc -vz 192.168.0.50 4713

PULSE_SERVER=tcp:192.168.0.50:4713 pactl info

### Configure:
here server is ip of the receiver:

pactl load-module module-tunnel-sink \
  server=tcp:192.168.0.50:4713 \
  sink_name=pi3_audio

pactl set-default-sink pi3_audio
pactl get-default-sink
### Verify 
pactl list short sink-inputs

# Configure Permenanently
### create startup script
mkdir -p ~/.local/bin
nano ~/.local/bin/pi3-audio-tunnel.sh

#!/bin/bash

PI3_SERVER="tcp:192.168.0.50:4713"
SINK_NAME="pi3_audio"

while true; do
    # Check whether the Pi 3 audio server is reachable
    if PULSE_SERVER="$PI3_SERVER" pactl info >/dev/null 2>&1; then

        # Create the tunnel if it does not already exist
        if ! pactl list short sinks | grep -q "[[:space:]]${SINK_NAME}[[:space:]]"; then
            pactl load-module module-tunnel-sink \
                server="$PI3_SERVER" \
                sink_name="$SINK_NAME" >/dev/null 2>&1
        fi

        # Select the Pi 3 as the default output
        if pactl list short sinks | grep -q "[[:space:]]${SINK_NAME}[[:space:]]"; then
            pactl set-default-sink "$SINK_NAME"
        fi

    else
        # Remove a stale tunnel while the Pi 3 is unreachable
        MODULE_IDS=$(pactl list short modules |
            awk '$2 == "module-tunnel-sink" &&
                 $0 ~ /sink_name=pi3_audio/ {print $1}')

        for ID in $MODULE_IDS; do
            pactl unload-module "$ID"
        done
    fi

    # Retry every five seconds
    sleep 5
done

chmod +x ~/.local/bin/pi3-audio-tunnel.sh

### Create system services
mkdir -p ~/.config/systemd/user
nano ~/.config/systemd/user/pi3-audio-tunnel.service


[Unit]
Description=Raspberry Pi 3 Network Audio Tunnel
After=pipewire-pulse.service
Wants=pipewire-pulse.service

[Service]
Type=simple
ExecStart=%h/.local/bin/pi3-audio-tunnel.sh
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target

systemctl --user daemon-reload
systemctl --user enable --now pi3-audio-tunnel.service

pactl list short sinks
pactl get-default-sink

### start it before login 
sudo loginctl enable-linger "$USER"
