# export PATH="$PATH:$HOME/.cargo/bin"
set cargo_path "$HOME/.cargo/bin/"
if test -d $cargo_path
    fish_add_path $cargo_path
end
