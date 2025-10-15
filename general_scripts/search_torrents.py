import os
import bencodepy




download_done = "/mnt/sda1/torrent_done/"  # Folder containing .torrent files to match
print("search path: " + download_done)

# Your qBittorrent BT_backup path
bt_backup = os.path.expanduser("~/.local/share/qBittorrent/BT_backup")


def find_and_delete(search_term):
    found = 0
    # Loop through .torrent files
    for filename in os.listdir(bt_backup):
        if filename.endswith(".torrent"):
            torrent_path = os.path.join(bt_backup, filename)
            fastresume_path = torrent_path.replace(".torrent", ".fastresume")
            try:
                with open(torrent_path, "rb") as f:
                    torrent = bencodepy.decode(f.read())
                    name = torrent[b'info'].get(b'name', b'').decode(errors='ignore')
                    if search_term in name.lower():
                        print("\n========================================")
                        print(f"Torrent name:   {name}")
                        print(f".torrent file:  {torrent_path}")
                        print(f".fastresume:    {fastresume_path}")

                        confirm = "y" # input("❓ Delete both files? [y/N]: ").strip().lower()
                        if confirm == "y":
                            os.remove(torrent_path)
                            if os.path.exists(fastresume_path):
                                os.remove(fastresume_path)
                            print("✅ Deleted.")
                            found += 1
                        else:
                            print("⏭️ Skipped.")
            except Exception as e:
                continue

    if found != 0:
        print(f"\n🗑️ Deleted {found} torrent(s).")

        
# === Step 1: Extract names from download_done/ ===
search_terms = set()

for file in os.listdir(download_done):
    if file.endswith(".torrent"):
        base_name = os.path.splitext(file)[0].strip().lower()
        if base_name:
            find_and_delete(base_name)
            search_terms.add(base_name)

print(f"📦 Loaded {len(search_terms)} search terms fromt torrent_done/ filenames")


