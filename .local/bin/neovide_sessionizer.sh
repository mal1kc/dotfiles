#!/bin/env bash

# Function to display help information
help() {
  echo "Usage: $0 <command> <session_name> [file] [cursor_position]"
  echo ""
  echo "This script manages Neovide sessions."
  echo ""
  echo "Commands:"
  echo "  _list            List all running Neovide sessions."
  echo "  _kill            Kill the specified Neovide session."
  echo "  _open            Open a file in the specified Neovide session."
  echo ""
  echo "Arguments:"
  echo "  session_name     Name of the Neovide session."
  echo "  file             (Optional) File to open in Neovide."
  echo "  cursor_position   (Optional) Cursor position to set (format: x,y). Default is 1,1."
  echo ""
  echo "Examples:"
  echo "  $0 _list"
  echo "  $0 _kill mysession"
  echo "  $0 _open mysession myfile.txt 1,1"
  exit 0
}

# If no arguments are provided, display help
if [[ -z $1 ]]; then
  help
fi

# If session_name is a directory (e.g. Godot's {project}), make one session per project
session_name=$2
project_dir=""
if [[ -n $2 && -d $2 ]]; then
  project_dir="$(cd "$2" && pwd -P)"
  session_name="$(basename "$project_dir")-$(printf %s "$project_dir" | md5sum | cut -c1-8)"
fi

# Define the Neovide session path
neovide_session_path="/tmp/neovide-$(whoami)-$session_name"

# List existing Neovide sessions
if [[ $1 == "_list" ]]; then
  echo "Running Neovide sessions:"
  ls /tmp/neovide-$(whoami)-* 2>/dev/null | sed 's|/tmp/||'
  exit 0
fi

# Kill a specific Neovide session
if [[ $1 == "_kill" ]]; then
  if [[ -z $2 ]]; then
    echo "Error: session_name is required for _kill command."
    help
    exit 1
  fi
  if [[ -S "$neovide_session_path" ]]; then
    neovide -- --server "$neovide_session_path" --remote-expr "exit" &>/dev/null
    rm -f "$neovide_session_path" # Remove the socket file
    echo "Killed Neovide session '$2'."
  else
    echo "No such session '$2' exists."
  fi
  exit 0
fi

# Open a file in a specific Neovide session
if [[ $1 == "_open" ]]; then
  if [[ -z $2 ]]; then
    echo "Error: session_name is required for _open command."
    help
  fi

  # Check if the Neovide session is already running
  if [[ ! -S "$neovide_session_path" ]]; then
    # Godot started with `--lsp-port N` -> tell nvim's gdscript LSP (GDScript_Port) to use it
    if [[ -z $GDScript_Port && -r /proc/$PPID/cmdline ]]; then
      GDScript_Port="$(tr '\0' '\n' </proc/$PPID/cmdline | grep -x -A1 -- --lsp-port | sed -n 2p)"
      [[ -n $GDScript_Port ]] && export GDScript_Port
    fi

    # Start a new Neovide session in the background (in the project dir if known)
    (cd "${project_dir:-.}" && neovide -- --listen "$neovide_session_path" &>/dev/null &)
    for _ in {1..50}; do # Wait up to 5s for the socket
      [[ -S "$neovide_session_path" ]] && break
      sleep 0.1
    done
  fi

  # If a file is provided, open it in Neovide
  file=$3
  cursor=$4
  if [[ -z $cursor ]]; then
    cursor="1,1" # Default cursor position
  fi

  if [[ -n $file ]]; then
    echo "Opening $file in Neovide session '$2'..."
    nvim --server "$neovide_session_path" --remote "$file" &>/dev/null
    nvim --server "$neovide_session_path" --remote-expr "cursor($cursor)" &>/dev/null
  else
    echo "No file specified. Neovide session '$2' is running."
  fi
fi
