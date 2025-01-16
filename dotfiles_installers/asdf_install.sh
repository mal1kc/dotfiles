#!/usr/bin/env bash
set -ex
install() {
	git clone https://github.com/asdf-vm/asdf.git ~/.local/share/asdf --branch v0.15.0
	mkdir -p "$HOME/.config/fish/completions" && ln -s "$HOME/.local/share/asdf/completions/asdf.fish" "$HOME/.config/fish/completions"
	. "$HOME/.local/share/asdf/asdf.sh"
	asdf plugin-add python
}

if [ "$1" = "install" ]; then
	install
fi
