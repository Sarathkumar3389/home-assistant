import asyncio
import glob
import sys
from pathlib import Path

# Add ~/home-assistant/ (2 levels up) to Python's module search path
ROOT_DIR = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT_DIR))

from tapo import ApiClient
from config_loader import get_device_config

# --- CONFIGURATION ---
DEVICE_KEY = "tapo_maccharger"
LOW_THRESHOLD = 45                 # Turn ON charger at or below this %
HIGH_THRESHOLD = 75                # Turn OFF charger at or above this %
# ---------------------

def get_battery_info():
    cap_files = glob.glob("/sys/class/power_supply/BAT*/capacity")
    status_files = glob.glob("/sys/class/power_supply/BAT*/status")
    
    if not cap_files:
        raise FileNotFoundError("Battery capacity file not found in /sys/class/power_supply/")
        
    with open(cap_files[0], "r") as f:
        capacity = int(f.read().strip())
        
    status = "Unknown"
    if status_files:
        with open(status_files[0], "r") as f:
            status = f.read().strip()
            
    return capacity, status

async def main():
    try:
        capacity, status = get_battery_info()
    except Exception as e:
        print(f"Error reading battery: {e}", file=sys.stderr)
        return

    # Only read config.json and connect when a threshold is crossed
    if capacity <= LOW_THRESHOLD and status != "Charging":
        cfg = get_device_config(DEVICE_KEY)
        print(f"Battery at {capacity}% ({status}). Turning plug ON at {cfg['ip']}...")
        client = ApiClient(cfg["email"], cfg["password"])
        device = await client.p110(cfg["ip"])
        await device.on()
        print("Plug turned ON.")

    elif capacity >= HIGH_THRESHOLD and status in ("Charging", "Full"):
        cfg = get_device_config(DEVICE_KEY)
        print(f"Battery at {capacity}% ({status}). Turning plug OFF at {cfg['ip']}...")
        client = ApiClient(cfg["email"], cfg["password"])
        device = await client.p110(cfg["ip"])
        await device.off()
        print("Plug turned OFF.")
    # else:
    #   print(f"Battery at {capacity}% ({status}). No Action Needed...")

if __name__ == "__main__":
    asyncio.run(main())
