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
    - Click Configure or the gear icon on your MQTT integration
    - Look for Add MQTT Device or Add MQTT Switch
    - Select "swtich" as type
    - Fill in:
      Name: Relay_Test
      Command Topic: home/relaytest
      State Topic: home/relaytest/state
      Payload On: ON
      Payload Off: OFF
      State On: ON
      State Off: OFF
      Retain: ✅
      Alarm Code: 9655514937

### Adding boolean Switches via UI
   - Go to Helpers 
   - Create helper
   #### Adding switch for delay and timeout purpose:
   - Create Toggle -> name it "relay_1_lockout"
      - For lock flag for auto lock to prevent ON again for some time, ``` input_boolean.relay_1_lockout ```
   - Create Toggele -> name it "relay_1_lockout_manual"
      -  For manual Lock flag if user locks, ``` input_boolean.relay_1_lockout_manual ```
   #### Adding real relay switch on UI:
   - Create Toggel -> name it "relay01"
      -  For actual ON/OFF switch for relay , ``` input_boolean.relay01 ```

### To Turn ON and Auto-Off and Manual lock
   - create this via the UI (“Settings → Automations & Scenes → + Create Automation → From YAML”) or directly add to your automations.yaml file:

    ```
      alias: Relay 1 Auto-Off and Lockout
description: Turns off relay_1 after 5 min and prevents reactivation for 2 min
triggers:
  - entity_id:
      - input_boolean.relay01
    to:
      - "on"
    trigger: state
    from:
      - "off"
conditions:
  - condition: state
    entity_id: input_boolean.relay_1_lockout
    state: "off"
  - condition: state
    entity_id: input_boolean.relay_1_lockout_manual
    state:
      - "off"
actions:
  - target:
      entity_id: switch.relay_test_relay_test
    action: switch.turn_on
    data: {}
  - target:
      entity_id: input_boolean.relay_1_lockout
    action: input_boolean.turn_on
    data: {}
    enabled: true
  - target:
      entity_id: input_boolean.relay_1_lockout_manual
    action: input_boolean.turn_on
    data: {}
  - delay: "00:00:05"
  - target:
      entity_id: switch.relay_test_relay_test
    action: switch.turn_off
    data: {}
  - action: input_boolean.turn_off
    target:
      entity_id:
        - input_boolean.relay01
    data: {}
  - delay: "00:00:05"
  - target:
      entity_id: input_boolean.relay_1_lockout
    action: input_boolean.turn_off
    data: {}
mode: restart

    ```

### To Turn OFF Manually
```
alias: Relay Test - Manual OFF
description: Turns off relay_1 after 5 min and prevents reactivation for 2 min
triggers:
  - entity_id:
      - input_boolean.relay01
    to:
      - "off"
    trigger: state
    from:
      - "on"
conditions: []
actions:
  - action: switch.turn_off
    target:
      entity_id:
        - switch.relay_test_relay_test
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
# UI - HOME


# UI - CCTV
## CCTV cards
These Yaml code can be added into entities
### Camera detections live view with Options
```
type: custom:frigate-card
frigate_url: http://192.168.0.10:5000/
camera_entity: camera.balcon
live:
  preload: true
media_viewer:
  transition: slide
cameras:
  - camera_entity: camera.balcon

```
### Camera detections gallary view
```
type: custom:frigate-card
frigate_url: http://192.168.0.10:5000/
camera_entity: camera.balcon
cameras:
  - camera_entity: camera.balcon
view:
  default: clips
```

# Notifications
1. Open Home Assistant Companion App (on your phone)
2. Go to App Settings
  Settings → Companion App → Notifications
  Turn ON notifications
3. In HA, 
  Settings → Devices & Services → Services → search “notify”


