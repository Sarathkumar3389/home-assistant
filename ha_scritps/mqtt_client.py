import paho.mqtt.client as mqtt
import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BCM)
PIN = 17
GPIO.setup(PIN, GPIO.OUT, initial=GPIO.HIGH)

BROKER = "192.168.0.18"
TOPIC_CMD = "home/relay1"
TOPIC_STATE = "home/relay1/state"
USERNAME = "sarathkumar"
PASSWORD = "9655514937"

def on_connect(client, userdata, flags, rc):
    print("Connected with code", rc)
    client.subscribe(TOPIC_CMD)

def on_message(client, userdata, msg):
    payload = msg.payload.decode()
    print(f"Received: {payload}")

    if payload == "ON":
        GPIO.output(PIN, GPIO.LOW)  # active LOW relay
        client.publish(TOPIC_STATE, "ON", retain=True)
    elif payload == "OFF":
        GPIO.output(PIN, GPIO.HIGH)
        client.publish(TOPIC_STATE, "OFF", retain=True)

client = mqtt.Client()
client.username_pw_set(USERNAME, PASSWORD)
client.on_connect = on_connect
client.on_message = on_message

client.connect(BROKER, 1883, 60)
print("Loop forever")
client.loop_forever()


