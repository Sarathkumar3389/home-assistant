import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)
PIN = 14
GPIO.setup(PIN, GPIO.OUT)

try:
    print("Relay ON")
    GPIO.output(PIN, GPIO.LOW)  # For active LOW relays
    time.sleep(2)

    print("Relay OFF")
    GPIO.output(PIN, GPIO.HIGH)
    time.sleep(2)

finally:
    print("Relay OFF")
    GPIO.cleanup()