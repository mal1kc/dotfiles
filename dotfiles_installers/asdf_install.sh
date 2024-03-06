#!/usr/bin/env bash
#
install(){
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
    mkdir -p "$HOME/.config/fish/completions" && ln -s "$HOME/.asdf/completions/asdf.fish" "$HOME/.config/fish/completions"
    . "$HOME/.asdf/asdf.sh"
    asdf plugin-add python
}


if [ "$1" = "install" ]; then
    install
fi
