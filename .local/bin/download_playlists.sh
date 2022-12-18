#!/bin/dash


$MUSIC_DIR = ~/Music
#yt-dlp -f "bestaudio" --continue --no-overwrites --ignore-errors -x --audio-format mp3 -o "./%(playlist_title)s/%(channel)s - %(title)s.%(ext)s" $1

# define urls for playlist vars
#

$perfect = "https://music.youtube.com/playlist?list=PLUqHRQQiRBMJfU-hUWKYvJ_GBANjRezMN"
$eyi = "https://music.youtube.com/playlist?list=PLUqHRQQiRBMLfPxNL6mTT35Ac5F0qzPC4"
$kafa_dinle = "https://music.youtube.com/playlist?list=PLUqHRQQiRBML1XCUwJFDVRVOJ7tPhZBEI"
$gaming_codin = "https://music.youtube.com/playlist?list=PLUqHRQQiRBMKU4CulD3QMRIyLrPPlobVO"
$bir_pesimistin_goz_ys = "https://music.youtube.com/playlist?list=OLAK5uy_njGXl-8uKZuChOkdHVhjzDozEkv8PykBw"

$dnri = "https://music.youtube.com/playlist?list=PLUqHRQQiRBMKBGl9IhmtS7umsKcn3jagx"
$anksiyete_mixtape = "https://music.youtube.com/playlist?list=PLUqHRQQiRBMIvaGgUbwu0wPoVGwRiPb8V"
$chilly_low_vol = "https://music.youtube.com/playlist?list=PLUqHRQQiRBMIUvstb9ql5Ene4SlMo9F0O"


function download_music_pl{
  if ! [ -z $2 ]
  then
    yt-dlp -f "bestaudio" --continue --no-overwrites --ignore-errors -x --audio-format mp3 -o "$MUSIC_DIR/$2/%(channel)s - %(title)s.%(ext)s" $1
  else
    yt-dlp -f "bestaudio" --continue --no-overwrites --ignore-errors -x --audio-format mp3 -o "$MUSIC_DIR/%(playlist_title)s/%(channel)s - %(title)s.%(ext)s" $1
  fi
}

if ! [ -z $1 ]
then
  for VAR do $n
    download_music_pl $VAR
  done
else
# 1st group
download_music_pl $perfect &
download_music_pl $eyi "eyi" &
download_music_pl $kafa_dinle &
download_music_pl $gaming_codin "gaming_codin"  &
download_music_pl $bir_pesimistin_goz_ys 
# 2nd group bigger ones
download_music_pl $dnri "dnri" & # this playlist is very big for co work
download_music_pl $anksiyete_mixtape "anksiyete_mixtape" &
download_music_pl $chilly_low_vol "chilly_low_vol" & # this playlist is very big for co work
