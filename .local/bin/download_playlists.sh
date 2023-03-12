#!/bin/dash

MUSIC_DIR=~/music

# define urls for playlist vars

download_music_pl(){
  echo "download stated - $(date '+%a %d %m - %T')" >> $MUSIC_DIR/status.txt
  if [ -n "$2" ]
  then
    yt-dlp -f "bestaudio" --continue --no-overwrites --ignore-errors -x --audio-format mp3 -o "$MUSIC_DIR/$2/%(channel)s - %(title)s.%(ext)s" "$1"
    echo "downloaded $2,$1" >> $MUSIC_DIR/status.txt
  else
    yt-dlp -f "bestaudio" --continue --no-overwrites --ignore-errors -x --audio-format mp3 -o "$MUSIC_DIR/%(playlist_title)s/%(channel)s - %(title)s.%(ext)s" "$1"
    echo "downloaded $1" >> $MUSIC_DIR/status.txt
  fi
}

if [ -n "$1" ]
then
  for VAR do $n
    download_music_pl "$VAR"
  done
else
  echo "no playlist_url given"
fi
