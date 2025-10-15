#!/bin/bash
#!/bin/bash
set -euo pipefail

# Usage: ./rsync_copy_with_progress.sh /source/folder /destination/folder

SRC="/mnt/sda1/download_done"
#SRC="/media/sarathkumar/59cd8c84-cf41-447e-8206-12e0a12ff455/download_done/"

#DEST="/media/sarathkumar/GeneralHDD/Movies/"

DEST="/mnt/usb/storage1/movies"


TARGET_DIR=$SRC

# --- Rename directories first (depth-first to avoid breaking paths) ---
find "$TARGET_DIR" -depth -type d | while IFS= read -r dir; do
    base=$(basename "$dir")
    parent=$(dirname "$dir")

    if [[ "$base" == *" - "* ]]; then
        new_base="${base#* - }"  # Remove up to and including first " - "
        new_path="$parent/$new_base"

        if [[ "$dir" != "$new_path" ]]; then
            echo "Renaming directory: $dir -> $new_path"
            mv "$dir" "$new_path"
        fi
    fi
done

# --- Rename files ---
find "$TARGET_DIR" -type f | while IFS= read -r file; do
    base=$(basename "$file")
    parent=$(dirname "$file")

    if [[ "$base" == *" - "* ]]; then
        new_base="${base#* - }"  # Remove up to and including first " - "
        new_path="$parent/$new_base"

        if [[ "$file" != "$new_path" ]]; then
            echo "Renaming file: $file -> $new_path"
            mv "$file" "$new_path"
        fi
    fi
done

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