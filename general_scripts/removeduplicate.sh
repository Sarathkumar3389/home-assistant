#!/bin/bash

folder_a="/mnt/sda1/torrent"  # Folder where you want to delete duplicates
folder_b="/mnt/sda1/torrent_done"  # Folder to check against

for file in "$folder_a"/*; do
    filename=$(basename "$file")
    if [ -f "$folder_b/$filename" ]; then
        echo "Deleting duplicate: $file"
        rm "$file"
    fi
done

#!/bin/bash

# Absolute or relative path to your virtual environment
VENV_DIR="$HOME/qbt-env"

# Path to your Python script
SCRIPT="search_torrents.py"

# Activate virtual environment
source "$VENV_DIR/bin/activate"

# Run the Python script
python "$SCRIPT"

# Deactivate the environment (optional)
deactivate


