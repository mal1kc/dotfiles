#!/bin/dash

MUSIC_DIR=~/music

# define urls for playlist vars

download_music_pl() {
	echo "download stated - $(date '+%a %d %m - %T')" >>$MUSIC_DIR/status.txt
	if [ -n "$2" ]; then
		yt-dlp -f "bestaudio" --continue --no-overwrites --ignore-errors -x --audio-format mp3 --add-metadata -o "$MUSIC_DIR/$2/%(artist)s - %(title)s.%(ext)s" "$1"
		echo "downloaded $2,$1" >>$MUSIC_DIR/status.txt
	else
		yt-dlp -f "bestaudio" --continue --no-overwrites --ignore-errors -x --audio-format mp3 --add-metadata -o "$MUSIC_DIR/%(playlist_title)s/%(artist)s - %(title)s.%(ext)s" "$1"
		echo "downloaded $1" >>$MUSIC_DIR/status.txt
	fi
}

if [ -n "$1" ] && [ -n "$2" ]; then
	download_music_pl "$1" "$2"
elif [ -n "$1" ]; then
	download_music_pl "$1"
else
	echo "playlist urls are given incorrectly"
fi
