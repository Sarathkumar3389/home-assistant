import paho.mqtt.client as mqtt
import RPi.GPIO as GPIO
import threading

GPIO.setmode(GPIO.BCM)
PIN = 17
GPIO.setup(PIN, GPIO.OUT, initial=GPIO.HIGH)

BROKER = "192.168.0.9" # IP Address of HA Server
TOPIC_CMD = "home/relaytest" # MQTT device configured in HA 
TOPIC_STATE = "home/relaytest/state"
USERNAME = "sarathkumar"
PASSWORD = "9655514937"

MAX_ON_TIME_MIN = 10

# Lock for thread safety
lock = threading.Lock()
max_on_timer = None  # Maximum ON duration timer

# Maximum ON duration handler
def max_off():
    global max_on_timer
    with lock:
        GPIO.output(PIN, GPIO.HIGH)  # Turn OFF relay
        client.publish(TOPIC_STATE, "OFF", retain=True)
        print("Relay turned OFF due to max ON duration")
        max_on_timer = None

def on_connect(client, userdata, flags, rc):
    print("Connected with code", rc)
    client.subscribe(TOPIC_CMD)

def on_message(client, userdata, msg):
    global max_on_timer
    payload = msg.payload.decode().upper()
    print(f"Received: {payload}")

    with lock:
        if payload == "ON":
            GPIO.output(PIN, GPIO.LOW)  # Active LOW relay
            client.publish(TOPIC_STATE, "ON", retain=True)
            print("Relay turned ON")

            # Cancel previous max ON timer if exists
            if max_on_timer:
                max_on_timer.cancel()
            
            # Start new max ON timer (10 minutes)
            max_on_timer = threading.Timer(MAX_ON_TIME_MIN*60, max_off)
            max_on_timer.start()

        elif payload == "OFF":
            GPIO.output(PIN, GPIO.HIGH)
            client.publish(TOPIC_STATE, "OFF", retain=True)
            print("Relay turned OFF manually")

            # Cancel any max ON timer
            if max_on_timer:
                max_on_timer.cancel()
                max_on_timer = None

client = mqtt.Client()
client.username_pw_set(USERNAME, PASSWORD)
client.on_connect = on_connect
client.on_message = on_message

client.connect(BROKER, 1883, 60)
print("Loop forever")
client.loop_forever()
