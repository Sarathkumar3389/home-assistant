from gpiozero import LED
import time

# relay is active LOW
relay = LED(17, active_high=False)

print("Relay manual control started.")
print("Type 'on', 'off', 'exit'.")

while True:
    cmd = input("Enter command: ").strip().lower()

    if cmd == "on":
        relay.on()     # sends LOW — activates relay
        print("Relay turned ON")

    elif cmd == "off":
        relay.off()    # sends HIGH — deactivates relay
        print("Relay turned OFF")

    elif cmd == "exit":
        print("Exiting...")
        relay.off()    # make sure relay is OFF before quitting
        break

    else:
        print("Invalid command. Use 'on', 'off', or 'exit'.")

    time.sleep(0.1)
