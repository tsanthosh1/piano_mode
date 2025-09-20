#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

DIR="$1"

if [ ! -d "$DIR" ]; then
  echo "Error: Directory '$DIR' does not exist."
  exit 1
fi

shopt -s nullglob
for file in "$DIR"/*.{jpg,jpeg,png,mp4}; do
  basename=$(basename "$file")

  # Extract datepart (always second part of filename)
  IFS='-' read -r prefix datepart rest <<< "$basename"

  if [[ ! $datepart =~ ^[0-9]{8}$ ]]; then
    echo "Skipping $basename (no date found)"
    continue
  fi

  # Parse year, month, day
  year=${datepart:0:4}
  month=${datepart:4:2}
  day=${datepart:6:2}

  datetime="${year}:${month}:${day} 12:00:00"

  echo "Setting $file -> DateTimeOriginal = $datetime"

  exiftool -overwrite_original \
  -DateTimeOriginal="$datetime" \
  -CreateDate="$datetime" \
  -ModifyDate="$datetime" \
  -FileCreateDate="$datetime" \
  -FileModifyDate="$datetime" \
  "$file"

done
