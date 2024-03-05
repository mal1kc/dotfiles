mkfileP() {
  mkdir -p "$(dirname "$1")" && touch "$1"
}

nvimMkFileP() {
  mkdir -p "$(dirname "$1")" && nvim "$1"
}
