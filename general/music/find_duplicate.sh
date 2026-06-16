#!/bin/bash

MUSIC_DIR="/media/sarathkumar"
OUTPUT="duplicate_songs.txt"

> "$OUTPUT"

find "$MUSIC_DIR" -type f \( \
    -iname "*.flac" -o \
    -iname "*.mp3" -o \
    -iname "*.m4a" -o \
    -iname "*.wav" \
\) > /tmp/music_files.txt

python3 << 'EOF'
import os
import subprocess
from collections import defaultdict

music_files = open("/tmp/music_files.txt").read().splitlines()

songs = defaultdict(list)

for f in music_files:
    name = os.path.splitext(os.path.basename(f))[0].lower()
    songs[name].append(f)

with open("duplicate_songs.txt","w",encoding="utf8") as out:

    for song, files in songs.items():

        if len(files) < 2:
            continue

        entries = []

        for f in files:

            ext = os.path.splitext(f)[1].lower()

            if ext == ".flac":
                score = 1000000
                bitrate = "LOSSLESS"

            else:
                try:
                    bitrate = subprocess.check_output([
                        "ffprobe",
                        "-v","quiet",
                        "-select_streams","a:0",
                        "-show_entries","stream=bit_rate",
                        "-of","default=noprint_wrappers=1:nokey=1",
                        f
                    ]).decode().strip()

                    score = int(bitrate or 0)

                except:
                    bitrate = "UNKNOWN"
                    score = 0

            size = os.path.getsize(f)

            entries.append({
                "file": f,
                "score": score,
                "bitrate": bitrate,
                "size": size
            })

        entries.sort(key=lambda x:(x["score"],x["size"]), reverse=True)

        out.write("="*80 + "\n")
        out.write(f"SONG: {song}\n")

        out.write("\nKEEP:\n")
        out.write(f"  {entries[0]['file']}\n")

        out.write("\nDELETE CANDIDATES:\n")

        for e in entries[1:]:
            out.write(
                f"  {e['file']} "
                f"(bitrate={e['bitrate']} size={e['size']})\n"
            )

        out.write("\n")

print("Report generated: duplicate_songs.txt")
EOF
