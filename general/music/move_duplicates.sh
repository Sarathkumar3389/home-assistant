#!/bin/bash

REPORT="duplicate_songs.txt"
TRASH="/media/sarathkumar/Music_01/TO_DELETE"

mkdir -p "$TRASH"

awk '
/DELETE CANDIDATES:/ {del=1; next}
/^================================================================================/ {del=0}
del && /^  \// {print}
' "$REPORT" |
sed 's/ (bitrate=.*//' |
while read -r file
do
    if [ -f "$file" ]; then

        # Preserve original directory structure
        relpath="${file#/media/sarathkumar/Music_01/}"
        dest="$TRASH/$relpath"

        mkdir -p "$(dirname "$dest")"

        echo "Moving: $file"
        mv "$file" "$dest"
    fi
done

echo "Done."