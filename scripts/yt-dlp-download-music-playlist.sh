#!/usr/bin/env sh
if [ -z "$1" ]; then
  echo "usage: $0 <playlist-url>" >&2
  exit 1
fi
yt-dlp -f "bestaudio" --continue --no-overwrites --ignore-errors -x --audio-format mp3 -o "./%(playlist_title)s/%(channel)s - %(title)s.%(ext)s" "$1"
