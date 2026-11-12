if [[ -d "$HOME/go/bin" ]] && [[ -z "$go_added_path" ]]; then
	export PATH="$PATH:$HOME/go/bin"
	export go_added_path=true
fi
