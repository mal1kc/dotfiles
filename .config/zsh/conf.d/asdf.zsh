if [[ -z "$asdf_initialized" ]]; then
	# Include go first && because I installed asdf via go
	source ~/.config/zsh/conf.d/go.zsh # Adjust the path if necessary

	# My custom location
	if command -v asdf >/dev/null; then
		asdf_loc="$XDG_DATA_HOME/asdf"
		mkdir -p "$asdf_loc"
		export ASDF_DATA_DIR="$asdf_loc"

		# ASDF configuration code
		if [[ -z "$ASDF_DATA_DIR" ]]; then
			_asdf_shims="$HOME/.asdf/shims"
		else
			_asdf_shims="$ASDF_DATA_DIR/shims"
		fi

		# Do not use `path+=` because it potentially changes the order of items in PATH
		if [[ ! ":$PATH:" == *":$_asdf_shims:"* ]]; then
			export PATH="$_asdf_shims:$PATH"
		fi

		# Generate completions
		mkdir -p "$HOME/.config/fish/completions"
		asdf completion zsh >"$HOME/.config/fish/completions/asdf.zsh"
	fi

	export asdf_initialized=true
fi
