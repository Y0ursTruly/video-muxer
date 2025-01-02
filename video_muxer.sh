#!/bin/bash

# the original was the .bat for windows then chatgpt turned the conversion from an adventure to a simple prompt lol

set -e  # Exit on error
shopt -s nullglob  # Ensure glob patterns that match no files expand to an empty array

# Process audio files
cd audios
filetype="mp3"
files="files.txt"
output="../output.${filetype}"

# Clear the output file without adding a blank line
: > "$files"

# Loop through all files in the current directory (lexically sorted)
for F in *; do
    ext="${F##*.}"
    # Consider only files of the desired filetype
    if [[ "${ext,,}" == "${filetype}" ]]; then
        echo "file '$F'" >> "$files"
    fi
done

ffmpeg -f concat -safe 0 -i "$files" -c copy "$output"
rm "$files"
cd ..

# Process video files
cd videos
filetype="mp4"
files="files.txt"
output="../output.${filetype}"

# Clear the output file without adding a blank line
: > "$files"

# Loop through all files in the current directory (lexically sorted)
for F in *; do
    ext="${F##*.}"
    # Consider only files of the desired filetype
    if [[ "${ext,,}" == "${filetype}" ]]; then
        echo "file '$F'" >> "$files"
    fi
done

ffmpeg -f concat -safe 0 -i "$files" -c copy "$output"
rm "$files"
cd ..

# Mux audio and video
ffmpeg -i output.mp4 -i output.mp3 -c:v copy -map 0:v -map 1:a -y muxed.mp4

# Clean up
rm -f output.mp3 output.mp4

echo "Video Successfully Compiled as muxed.mp4"
