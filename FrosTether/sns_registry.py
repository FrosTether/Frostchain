import json, os

REGISTRY_PATH = os.path.expanduser("~/FrosTether/registry.json")

def load_registry():
    if not os.path.exists(REGISTRY_PATH):
        # Initializing with your Doge and EVM identity
        return {
            "architect.frostchain": {
                "evm_addr": "0xYourNewAddressFromForge",
                "doge_addr": "DJTDVRxJGtcuSsxwT7GHbkdCabqaTa1C7s",
                "label": "Master Architect"
            }
        }
    with open(REGISTRY_PATH, 'r') as f: return json.load(f)

def resolve(name):
    reg = load_registry()
    if name in reg:
        return reg[name]
    return None

if __name__ == "__main__":
    print("\033[1;36m[SNS] FROSTCHAIN NAME SERVICE\033[0m")
    name = input("Resolve Name: ").strip()
    result = resolve(name)
    if result:
        print(f"\033[1;32m[RESOLVED]\033[0m {name} -> {result['evm_addr']}")
    else:
        print("\033[1;31m[ERROR]\033[0m Name not found in registry.")
