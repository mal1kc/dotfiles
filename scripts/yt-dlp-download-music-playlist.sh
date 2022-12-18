#!/bin/env sh
yt-dlp -f "bestaudio" --continue --no-overwrites --ignore-errors -x --audio-format mp3 -o "./%(playlist_title)s/%(channel)s - %(title)s.%(ext)s" $1
