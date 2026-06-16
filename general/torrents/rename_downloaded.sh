#!/bin/bash
set -uo pipefail  # remove -e so script doesn't exit on harmless find errors

SRC="/mnt/sda1/download_done"
TARGET_DIR=$SRC

echo "=== Items that will be renamed (folders + files) ==="

count=0
echo "=== Preview ==="

rename_count=0
skip_count=0

process_item() {
    local path="$1"

    base=$(basename -- "$path")
    parent=$(dirname -- "$path")
    prefix="${base%% - *}"

    # Skip if no " - "
    prefix="${base%% - *}"

    if [[ "$prefix" == www.* ]]; then
        new_base="${base#* - }"
    else
        echo "SKIP   : $base"
        ((skip_count++))
        return
    fi

    new_base="${base#* - }"

    if [[ "$base" == "$new_base" ]]; then
        echo "SKIP   : $base"
        ((skip_count++))
        return
    fi

    echo "RENAME : $base"
    echo "         -> $new_base"
    echo

    ((rename_count++))
}
# Preview folders
while IFS= read -r dir; do
    process_item "$dir"
done < <(find "$TARGET_DIR" -depth -type d -name "* - *" 2>/dev/null)

# Preview files
while IFS= read -r file; do
    process_item "$file"
done < <(find "$TARGET_DIR" -type f -name "* - *" 2>/dev/null)

echo
echo "===================================="
echo "Items to rename : $rename_count"
echo "Items skipped   : $skip_count"
echo "===================================="

if [[ $rename_count -eq 0 ]]; then
    echo
    echo "No matching items found. Nothing to rename."
    exit 0
fi

echo
echo "Total items to be renamed: $rename_count"

read -p "Proceed with renaming? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
    echo "❌ Operation cancelled."
    exit 0
fi

echo
echo "=== Renaming folders (deepest first) ==="
find "$TARGET_DIR" -depth -type d -name "* - *" 2>/dev/null |
while IFS= read -r dir; do
    base=$(basename -- "$dir")
    parent=$(dirname -- "$dir")

    prefix="${base%% - *}"

    if [[ "$prefix" == www.* ]]; then
        new_base="${base#* - }"
    else
        continue
    fi

    new_path="$parent/$new_base"

    echo "Renaming folder: $base → $new_base"
    mv -v -- "$dir" "$new_path"
done

echo
echo "=== Renaming files ==="
find "$TARGET_DIR" -type f -name "* - *" 2>/dev/null |
while IFS= read -r file; do
    base=$(basename -- "$file")
    parent=$(dirname -- "$file")

    prefix="${base%% - *}"

    if [[ "$prefix" != "$base" && "$prefix" != *"("* && "$prefix" != *")"* ]]; then
        new_base="${base#* - }"
    else
        continue
    fi

    new_path="$parent/$new_base"

    echo "Renaming file: $base → $new_base"
    mv -v -- "$file" "$new_path"
done

echo
echo "✅ Rename complete!"


