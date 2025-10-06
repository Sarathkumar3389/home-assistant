# Home-assistant
My Home assistant 

# Relay Control 
## Run the Client 
python3 /home/sarathkumar/home-assistant/ha_scritps/mqtt_client.py

## In HA:
 Method: Use Home Assistant UI to Create an MQTT Switch
1️⃣ Go to Integrations

Open Home Assistant → Settings → Devices & Services → Integrations

Click your MQTT broker (e.g., Mosquitto MQTT)

2️⃣ Add MQTT Switch via UI

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