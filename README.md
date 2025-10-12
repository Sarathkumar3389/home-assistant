# Home-assistant
My Home assistant 

# Relay Control 
## In Relay Control Device:  Run the Client 
python3 /home/sarathkumar/home-assistant/ha_scritps/mqtt_client.py
### To run the script at startup
 1. Create a new service file

    ```sudo nano /etc/systemd/system/mqtt_client.service```


 2. Add the below content
   ```
   [Unit]
    Description=MQTT Client Script
    After=network.target

    [Service]
    ExecStart=/usr/bin/python3 /home/sarathkumar/home-assistant/ha_scritps/mqtt_client.py
    WorkingDirectory=/home/sarathkumar/home-assistant/ha_scritps
    StandardOutput=inherit
    StandardError=inherit
    Restart=always
    User=sarathkumar

    [Install]
    WantedBy=multi-user.target
   ```
3.  Enable the service
```
    sudo systemctl daemon-reload
    sudo systemctl enable mqtt_client.service
    sudo systemctl start mqtt_client.service
```


## In HomeAssistant:
 Method: Use Home Assistant UI to Create an MQTT Switch
1️.  Go to Integrations

Open Home Assistant → Settings → Devices & Services → Integrations

Click your MQTT broker (e.g., Mosquitto MQTT)

2️. Add MQTT Switch via UI

Click Configure or the gear icon on your MQTT integration

Look for Add MQTT Device or Add MQTT Switch

Fill in:

Name: Relay 1

Command Topic: home/relay1

State Topic: home/relay1/state

Payload On: ON

Payload Off: OFF

State On: ON

State Off: OFF

Retain: ✅

### To auto-off 
create this via the UI (“Settings → Automations & Scenes → + Create Automation → From YAML”) or directly add to your automations.yaml file:

```
    alias: Turn off relay_1 after 5 minutes
    description: Automatically turns off relay_1 5 minutes after being turned on
    trigger:
    - platform: state
        entity_id: switch.relay_1
        to: "on"
    action:
    - delay: "00:05:00"   # 5 minutes
    - service: switch.turn_off
        target:
        entity_id: switch.relay_1
    mode: restart
```

### To prevent ON immediately after OFF (misuse)
#### Step1 :
```
alias: Prevent Relay 1 ON During Lockout
triggers:
  - entity_id: switch.relay_1
    to: "on"
    trigger: state
conditions:
  - condition: state
    entity_id: input_boolean.relay_1_lockout
    state: "on"
actions:
  - target:
      entity_id: switch.relay_1
    action: switch.turn_off
    data: {}
  - data:
      title: Relay Lockout Active
      message: Relay cannot be turned ON yet.
    action: persistent_notification.create
mode: single

```
 #### Step 2 — Add a “Gatekeeper” Automation (Allow ON Only If Enabled)

```

alias: Relay 1 Auto-Off and Lockout
description: Turns off relay_1 after 5 min and prevents reactivation for 2 min
triggers:
  - entity_id: switch.relay_1
    to: "on"
    trigger: state
actions:
  - target:
      entity_id: input_boolean.relay_1_lockout
    action: input_boolean.turn_on
    data: {}
  - delay: "00:00:05"
  - target:
      entity_id: switch.relay_1
    action: switch.turn_off
    data: {}
  - delay: "00:00:05"
  - target:
      entity_id: input_boolean.relay_1_lockout
    action: input_boolean.turn_off
    data: {}
mode: restart


```