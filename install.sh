#!/bin/bash

# Specify the directory containing your dotfiles
DOTFILES_DIR="$HOME/dotfiles"

# Specify the directory containing installer scripts
INSTALLER_DIR="$DOTFILES_DIR/dotfiles_installers"

# Specify the directory for backup archives
BACKUP_ARCHIVE_DIR="$HOME/.dotfiles_backup_archive"

# Specify the directory for overwrite backups
OVERWRT_BACKUP_DIR="/tmp/dotfiles_overwrite_backup"

# Backup directory for temporary backup for creating archive
BACKUP_DIR="/tmp/dotfiles_backup"

# Specify the directory for temporary backup extraction
BACKUP_EXTRACTION_DIR="/tmp/dotfiles_backup_extract"

# List of dotfiles to be installed
# . files from dotfiles_installers/
# finded by find command
# and converted to array
# Use find command to find dotfiles in dotfiles_installers directory

cd "$DOTFILES_DIR" || {
	echo "Error: Failed to change directory to $DOTFILES_DIR"
	exit 1
}

dotfiles_list=$(command ls -A)

DOTFILES=()

# Convert the newline-separated output into an array
readarray -t DOTFILES <<<"$dotfiles_list"

# Print the dotfiles array
printf '%s\n' "${DOTFILES[@]}"

# List of ignored files
IGNORE_FILES=(
	.git
	.gitignore
	.gitmodules
	.firefox_scripts_configs/
	.pre-commit-config.yaml
	scripts
	dotfiles_installers
	pkg_list.txt
	nix_profile_pkg_list.txt
	install.sh
	readme.org
)

# List of ignored scripts
IGNORE_SCRIPTS=(
	archlinux_and_aur_install.sh # TODO: fix script
)

# Array to store overwritten dotfiles
OVERWRT_DOTFILES=()

# Function to remove ignored files from the dotfiles array
rm_ignore_files() {
	echo "Removing ignored files from the dotfiles array"
	dotfile_count=${#DOTFILES[@]}
	for ignore in "${IGNORE_FILES[@]}"; do
		for i in "${!DOTFILES[@]}"; do
			if [[ "${DOTFILES[$i]}" = "$ignore" ]]; then
				unset 'DOTFILES[i]'
			fi
		done
	done

	echo "Removed $((dotfile_count - ${#DOTFILES[@]})) ignored files from the dotfiles array"
}

# Function to remove ignored scripts from the installer directory
rm_ignore_scripts() {
	echo "Removing ignored scripts from the installer array"
	script_count=${#INSTALLER_SCRIPTS[@]}
	for ignore in "${IGNORE_SCRIPTS[@]}"; do
		for i in "${!INSTALLER_SCRIPTS[@]}"; do
			if [[ "${INSTALLER_SCRIPTS[$i]}" = "$ignore" ]]; then
				unset 'INSTALLER_SCRIPTS[i]'
			fi
		done
	done
	echo "Removed $((script_count - ${#INSTALLER_SCRIPTS[@]})) ignored scripts from the installer array"
}

# Function to create necessary directories
create_dirs() {
	echo "Creating necessary directories"
	echo "BACKUP_ARCHIVE_DIR: $BACKUP_ARCHIVE_DIR"
	echo "BACKUP_DIR: $BACKUP_DIR"
	echo "BACKUP_EXTRACTION_DIR: $BACKUP_EXTRACTION_DIR"
	echo "OVERWRT_BACKUP_DIR: $OVERWRT_BACKUP_DIR"

	rm -rf "$BACKUP_DIR" "$BACKUP_EXTRACTION_DIR" "$OVERWRT_BACKUP_DIR" || {
		echo "Error: Failed to remove existing tmp directories"
		exit 1
	}

	mkdir -p "$BACKUP_ARCHIVE_DIR" "$BACKUP_DIR" "$BACKUP_EXTRACTION_DIR" "$OVERWRT_BACKUP_DIR" || {
		echo "Error: Failed to create backup directories"
		exit 1
	}

}

# Function to remove old backups older than 30 days
rm_old_backups() {
	find "$BACKUP_ARCHIVE_DIR" -type f -mtime +30 -exec rm {} \;
}

# Function to create an archive of overwrite backups
archive_overwrt_backup() {
	date_time=$(date "+%Y%m%d_%H%M%S")
	arch_path="$BACKUP_ARCHIVE_DIR/dotfiles_overwrite_backup$date_time.tar.gz"
	echo "Creating overwrite backup archive at $arch_path"
	arch_status=$(tar -czf "$arch_path" -C "$OVERWRT_BACKUP_DIR" .)
	if [[ "$arch_status" -eq 0 ]]; then
		rm -rf "$OVERWRT_BACKUP_DIR" &&
			echo "Overwrite backup created: dotfiles_overwrite_backup$date_time.tar.gz"
		mkdir -p "$OVERWRT_BACKUP_DIR"
	else
		echo "Error: Failed to create overwrite backup archive"
	fi
}

# Function to install dotfiles
install_dotfiles() {
	rm_ignore_files
	install_fn="install_dotfile"
	if [ "$1" = "nobackup" ]; then
		install_fn="install_dotfile_nobc"
	fi
	for dfile in "${DOTFILES[@]}"; do
		if [ -d "$DOTFILES_DIR/$dfile" ]; then
			echo "Installing subdirectory: $dfile"
			mkdir -p "$HOME/$(dirname "$dfile")"
			continue
		fi
		$install_fn "$dfile"
	done
	if [ "${#OVERWRT_DOTFILES[@]}" -gt 0 ]; then
		archive_overwrt_backup
	fi
}

# Function to install individual dotfiles
install_dotfile() {
	if [ -e "$DOTFILES_DIR/$1" ]; then
		echo "Installing dotfile: $1"
		if [ -e "$HOME/$1" ]; then
			if [ -L "$HOME/$1" ]; then
				echo "Removing existing symlink: $HOME/$1"
				rm "$HOME/$1"
			else
				echo "Moving existing dotfile to overwrite backup: $HOME/$1 -> $OVERWRT_BACKUP_DIR/$1"
				file_size=$(du -b "/path/to/file" | awk '{print $1}')

				if [ "$file_size" -gt 20971520 ]; then
				    echo "File size is greater than 20 MB"
				    echo "probably this script doing some bad stuff"
					exit 1
				fi
				mv "$HOME/$1" "$OVERWRT_BACKUP_DIR/$1"
				OVERWRT_DOTFILES+=("$1")
			fi
		fi
		echo "Creating symlink: $DOTFILES_DIR/$1 -> $HOME/$1"
		ln -s "$(realpath "$DOTFILES_DIR/$1")" "$HOME/$1" || echo "Error: Failed to create symlink: $DOTFILES_DIR/$1 -> $HOME/$1"
	else
		echo "Error: $1 not found in dotfiles directory."
	fi
}

install_dotfile_nobc() {

	echo "try to installing dotfile: $DOTFILES_DIR/$1 -> $HOME/$1"
	if [ -e "$DOTFILES_DIR/$1" ]; then
		if [ -e "$HOME/$1" ]; then
			if [ -L "$HOME/$1" ]; then
				echo "Removing existing symlink: $HOME/$1"
				rm "$HOME/$1"
			fi
		fi
		echo "Creating symlink: $DOTFILES_DIR/$1 -> $HOME/$1"
		ln -s "$(realpath "$DOTFILES_DIR/$1")" "$HOME/$1" || echo "Error: Failed to create symlink: $DOTFILES_DIR/$1 -> $HOME/$1"
	else
		echo "Error: $1 not found in dotfiles directory."
	fi
}

# Function to install scripts
install_scripts() {
	rm_ignore_scripts
	for script in "$INSTALLER_DIR"/*; do
		if [ -x "$script" ]; then
			echo "Running $script"
			"$script" install >/tmp/dotfiles_install.log
		fi
	done
}

backup_dotfiles() {
	rm_ignore_files
	for dfile in "${DOTFILES[@]}"; do
		if [ -e "$HOME/$dfile" ]; then
			echo "Backing up dotfile: $HOME/$dfile -> $BACKUP_DIR/$dfile"
			cp -r "$HOME/$dfile" "$BACKUP_DIR/$dfile"
		fi
	done
	archive_backup
}

# Function to display help
show_help() {
	echo "Usage: $0 [install|uninstall|backup|help]"
	echo "  install             Install dotfiles (symlinks) and scripts, create backups ( only overwrite files)."
	echo "  nobcinstall         Install dotfiles (symlinks) and scripts, without creating backups."
	echo "  uninstall           Uninstall dotfiles, restore backups if available."
	echo "  backup              Create a backup of existing dotfiles. (full backup files)"
	echo "  list_backups        List all backups of existing dotfiles."
	echo "  restore_backup      Restore a backup of existing dotfiles."
	echo "  list_overwrite_backups    List all backups of overwritten dotfiles."
	echo "  remove_old_backups  Remove archive backups older than 30 days."
	echo "  help                Show this help message."
}

# Main function
main() {
	case "$1" in
	install)
		install_dotfiles
		install_scripts
		;;
	nobcinstall)
		install_dotfiles nobackup
		;;
	uninstall)
		uninstall_dotfiles
		;;
	backup)
		backup_dotfiles
		;;
	list_backups)
		ls -l "$BACKUP_ARCHIVE_DIR"
		;;
	restore_backup)
		restore_backup
		;;
	list_overwrite_backups)
		fd -t f -d 1 "$BACKUP_ARCHIVE_DIR" -e tar.gz | grep -E 'dotfiles_overwrite_backup[0-9]{8}_[0-9]{6}.tar.gz'
		;;
	remove_old_backups)
		rm_old_backups
		;;
	help)
		show_help
		;;
	*)
		show_help
		exit 1
		;;
	esac
}

# Call main function
create_dirs
main "$@" 2>&1 | tee /tmp/dotfiles_install.log
