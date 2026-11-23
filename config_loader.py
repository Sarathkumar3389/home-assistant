import json
import sys
from pathlib import Path

CONFIG_PATH = Path(__file__).parent / "config.json"

def get_device_config(identifier: str, config_path: Path = CONFIG_PATH) -> dict:
    """Returns the full dictionary (ip, email, password, etc.) for a device key or hostname."""
    with open(config_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    devices = data.get("devices", {})

    if identifier in devices:
        return devices[identifier]

    for dev_info in devices.values():
        if dev_info.get("hostname") == identifier:
            return dev_info

    raise KeyError(f"Device '{identifier}' not found in {config_path}")

def get_device_ip(identifier: str, config_path: Path = CONFIG_PATH) -> str:
    """Helper to fetch just the IP address."""
    device = get_device_config(identifier, config_path)
    if "ip" not in device:
        raise KeyError(f"'ip' field missing for device '{identifier}' in {config_path}")
    return device["ip"]

if __name__ == "__main__":
    target = sys.argv[1] if len(sys.argv) > 1 else "tapo_maccharger"
    print(get_device_ip(target))
    print(get_device_config(target))
