#!/bin/bash

# Set the working directory (Change this to your desired path)
WORK_DIR="/Users/tsanthosh/Documents/vid"
mkdir -p $WORK_DIR
cd "$WORK_DIR" || exit

# Input YouTube URL and time range eg: https://www.youtube.com/watch?v=bNmjuRI0kow&start=0&end=43
YOUTUBE_URL="$1"

# Parse start and end times using BSD-compatible grep and sed
START_TIME=$(echo "${YOUTUBE_URL}" | grep -o 'start=[0-9\.]*' | sed 's/start=//')
END_TIME=$(echo "${YOUTUBE_URL}" | grep -o 'end=[0-9\.]*' | sed 's/end=//')


# Validate times
if [ -z "$START_TIME" ]; then
    START_TIME="0"
fi

if [ -z "$END_TIME" ]; then
    echo "Error: End time not specified in URL"
    exit 1
fi

# Extract Video ID from URL - making this more robust
VIDEO_ID=$(echo "${YOUTUBE_URL}" | sed 's/.*v=\([^&]*\).*/\1/')

# Output filenames
VIDEO_FILE="${VIDEO_ID}.mp4"
OUTPUT_DIR="${WORK_DIR}/trimmed_videos"
mkdir -p $OUTPUT_DIR
TRIMMED_FILE="${OUTPUT_DIR}/${VIDEO_ID}_${START_TIME}_${END_TIME}.mp4"

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# Check if video is already downloaded
if [ ! -f "$VIDEO_FILE" ]; then
    echo "Downloading video..."
    yt-dlp -o "$VIDEO_FILE" -f "bestvideo[ext=mp4][vcodec^=avc1]+bestaudio[ext=m4a]/best[ext=mp4]/best"  --merge-output-format mp4 "${YOUTUBE_URL}"

else
    echo "Video already exists, skipping download."
fi

# Trim the video
echo "Trimming video... with ffmpeg -y -i ${WORK_DIR}/${VIDEO_FILE} -ss $START_TIME -to $END_TIME -c:v libx264 -preset fast -c:a aac -b:a 192k $TRIMMED_FILE"
ffmpeg -y -i "$VIDEO_FILE" -ss "$START_TIME" -to "$END_TIME" -c:v copy -c:a copy "$TRIMMED_FILE"


echo "Trimmed video saved to: $TRIMMED_FILE"
