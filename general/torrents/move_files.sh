#!/bin/bash
#!/bin/bash
set -euo pipefail

# Usage: ./rsync_copy_with_progress.sh /source/folder /destination/folder

SRC="/mnt/sda1/download_done"
#DEST="/media/sarathkumar/GeneralHDD/Movies/"

DEST="/mnt/usb/storage1/movies"

# Check arguments
if [[ -z "$SRC" || -z "$DEST" ]]; then
    echo "Usage: $0 /source/folder /destination/folder"
    exit 1
fi

if [[ ! -d "$SRC" ]]; then
    echo "Error: Source directory '$SRC' does not exist."
    exit 1
fi

if [[ ! -d "$DEST" ]]; then
    echo "❌ Error: Destination directory '$DEST' does not exist."
    exit 1
fi

echo "🔄 Moving files from: $SRC to $DEST"
echo


# Move with rsync (copy + delete from source)
# rsync -a --remove-source-files --info=progress2 --human-readable "$SRC"/ "$DEST"/
rsync -a --partial --inplace --remove-source-files --info=progress2 --human-readable "$SRC"/ "$DEST"/


# echo 
# rm -r "$SRC"/*
echo 
echo "✅ Copy complete!"

echo "--------------- remove duplicate .torrent files ---------------"
# ./removeduplicate.sh

# Find and remove empty directories *inside* the given directory,
# but do NOT delete the directory itself
find "$SRC" -mindepth 1 -type d -empty -delete

echo "All empty folders inside '$SRC' have been removed."
