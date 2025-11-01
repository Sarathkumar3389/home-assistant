#!/bin/bash
set -uo pipefail  # remove -e so script doesn't exit on harmless find errors

SRC="/mnt/sda1/download_done"
TARGET_DIR=$SRC

echo "=== Items that will be renamed (folders + files) ==="

count=0

# Preview folders (deepest first)
while IFS= read -r dir; do
    [[ -z "$dir" ]] && continue
    base=$(basename -- "$dir")
    parent=$(dirname -- "$dir")
    new_base="${base#* - }"
    new_path="$parent/$new_base"
    if [[ "$dir" != "$new_path" ]]; then
        echo "$new_base"
        ((count++))
    fi
done < <(find "$TARGET_DIR" -depth -type d -name "* - *" 2>/dev/null || true)

# Preview files
while IFS= read -r file; do
    [[ -z "$file" ]] && continue
    base=$(basename -- "$file")
    parent=$(dirname -- "$file")
    new_base="${base#* - }"
    new_path="$parent/$new_base"
    if [[ "$file" != "$new_path" ]]; then
        echo "$new_base"
        ((count++))
    fi
done < <(find "$TARGET_DIR" -type f -name "* - *" 2>/dev/null || true)

if [[ $count -eq 0 ]]; then
    echo
    echo "No matching items found. Nothing to rename."
    exit 0
fi

echo
echo "Total items to be renamed: $count"
read -p "Proceed with renaming? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
    echo "❌ Operation cancelled."
    exit 0
fi

echo
echo "=== Renaming folders (deepest first) ==="
find "$TARGET_DIR" -depth -type d -name "* - *" 2>/dev/null | while IFS= read -r dir; do
    [[ -z "$dir" ]] && continue
    base=$(basename -- "$dir")
    parent=$(dirname -- "$dir")
    new_base="${base#* - }"
    new_path="$parent/$new_base"
    if [[ "$dir" != "$new_path" ]]; then
        echo "Renaming folder: $base → $new_base"
        mv -v "$dir" "$new_path"
    fi
done

echo
echo "=== Renaming files ==="
find "$TARGET_DIR" -type f -name "* - *" 2>/dev/null | while IFS= read -r file; do
    [[ -z "$file" ]] && continue
    base=$(basename -- "$file")
    parent=$(dirname -- "$file")
    new_base="${base#* - }"
    new_path="$parent/$new_base"
    if [[ "$file" != "$new_path" ]]; then
        echo "Renaming file: $base → $new_base"
        mv -v "$file" "$new_path"
    fi
done

echo
echo "✅ Rename complete!"
