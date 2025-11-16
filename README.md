# General Scripts
# In order to avoid having to type your git password multiple times, you may set
git config --global credential.helper 'cache --timeout=3600'

# or, as we work with tokens, you can just go for permanent storage
git config --global credential.helper store



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

### Add boolean Switch via UI
   For lock flag for auto lock to prevent ON again for some time, ``` input_boolean.relay_1_lockout ```
   For manual Lock flag if user locks, ``` input_boolean.relay_1_lockout_manual ```


### To Turn On and Auto-Off and Manual lock
create this via the UI (“Settings → Automations & Scenes → + Create Automation → From YAML”) or directly add to your automations.yaml file:

```
  alias: Relay 1 Auto-Off and Lockout
description: Turns off relay_1 after 5 min and prevents reactivation for 2 min
triggers:
  - entity_id:
      - input_boolean.relay01
    to: "on"
    trigger: state
conditions:
  - condition: state
    entity_id: input_boolean.relay_1_lockout
    state: "off"
  - condition: state
    entity_id: input_boolean.relay_1_lockout_manual
    state: "off"
actions:
  - target:
      entity_id: switch.relay_1
    action: switch.turn_on
    data: {}
  - target:
      entity_id: input_boolean.relay_1_lockout
    action: input_boolean.turn_on
    data: {}
  - target:
      entity_id: input_boolean.relay_1_lockout_manual
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

## HA Issue
1. Webterminal add not starting
 - in Configuration username and PW has to be set to start it
2. SD card logging issue
  - set in Configuration.yaml
    logging:
      deafult:error 

## Frigate Add-On
### Adding frigate stream
- via HACs 
- Add Frigate url : http://192.168.0.10:5000/
- no username and PW
### Install MQTT
- Add-On store 
- Download and add integration
```
logins:
  - username: mqtt
    password: "yourpassword"
require_certificate: false
certfile: fullchain.pem
keyfile: privkey.pem
customize:
  active: false
  folder: mosquitto

```
