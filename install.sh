#!/bin/bash

# Specify the directory containing your dotfiles
DOTFILES_DIR="$HOME/dotfiles"

# Specify the directory containing installer scripts
# TODO: is really necessary to have installer scripts?
# INSTALLER_DIR="$DOTFILES_DIR/.dotfiles_installers"

BACKUP_ARCHIVE_DIR="$HOME/.dotfiles_backup_archive"

OVERWRT_BACKUP_DIR="$HOME/.dotfiles_overwrite_backup"

BACKUP_EXTRACTION_DIR="/tmp/dotfiles_backup_extract"

BACKUP_DIR="$HOME/.dotfiles_backup_archive"

# List of dotfiles to be installed
# git  ls-files in the dotfiles directory to get the list of dotfiles
DOTFILES=$(git ls-files | grep -E '^\.[a-zA-Z0-9_]+')
# array to store overwritten dotfiles
OVERWRT_DOTFILES=()

# create overwrite backup directory if it does not exist

check_dirs() {
	if [ ! -d "$BACKUP_ARCHIVE_DIR" ]; then
		mkdir -p "$BACKUP_ARCHIVE_DIR"
	fi
	if [ ! -d "$BACKUP_DIR" ]; then
		mkdir -p "$BACKUP_DIR"
	fi
	if [ ! -d "$BACKUP_EXTRACTION_DIR" ]; then
		mkdir -p "$BACKUP_EXTRACTION_DIR"
	fi
}

rm_old_backups() {
	# remove backups older than 30 days
	find "$BACKUP_ARCHIVE_DIR" -type f -mtime +30 -exec rm {} \;
}

archive_overwrt_backup() {
	# Create a tar file containing all existing dotfiles
	date_time=$(date "+%Y%m%d_%H%M%S")
	arch_status=$(tar -czf "$BACKUP_ARCHIVE_DIR/dotfiles_overwrite_backup$date_time.tar.gz" -C "$OVERWRT_BACKUP_DIR" .)
	if [ "$arch_status" -eq 0 ]; then
		rm -rf "$OVERWRT_BACKUP_DIR" &&
			echo "Overwrite backup created: dotfiles_overwrite_backup$date_time.tar.gz"
		mkdir -p "$OVERWRT_BACKUP_DIR"
	else
		echo "Error: failed to create overwrite backup archive"
	fi
}

install_dotfiles() {
	for dfile in "${DOTFILES[@]}"; do
		# Check if the dotfile exists
		if [ -e "$DOTFILES_DIR/$dfile" ]; then
			# Backup existing dotfile if it exists
			if [ -e "$HOME/$dfile" ]; then
				# check if the dotfile is a symlink

				if [ -L "$HOME/$dfile" ]; then
					# remove the symlink
					rm "$HOME/$dfile"
				else
					# Move the existing dotfile to the overwrite backup directory
					mv "$HOME/$dfile" "$OVERWRT_BACKUP_DIR/$dfile"
					OVERWRT_DOTFILES+=("$dfile")
				fi
			fi
			# Create symlink to the dotfile
			ln -s "$DOTFILES_DIR/$dfile" "$HOME/$dfile"
			echo "Installed $dfile"
		else
			echo "Error: $dfile not found in dotfiles directory."
		fi
	done
	archive_overwrt_backup
}
archive_backup() {
	# Create a tar file containing all existing dotfiles
	date_time=$(date "+%Y%m%d_%H%M%S")
	# if archive created successfully, remove the backup directory data

	arch_status=$(tar -czf "$BACKUP_ARCHIVE_DIR/dotfiles_backup$date_time.tar.gz" -C "$BACKUP_DIR" .)
	if [ "$arch_status" -eq 0 ]; then
		rm -rf "$BACKUP_DIR" &&
			echo "Backup created: dotfiles_backup$date_time.tar.gz"
		mkdir -p "$BACKUP_DIR"
	else
		echo "Error: failed to create backup archive"
	fi
}

# Function to create a backup of existing dotfiles
backup_dotfiles() {
	# Create a tar file containing all existing dotfiles
	for dfile in "${DOTFILES[@]}"; do
		# Check if the dotfile exists
		if [ -e "$HOME/$dfile" ]; then
			# Create a backup of the dotfile
			cp -r "$HOME/$dfile" "$BACKUP_DIR/$dfile"
			echo "Backed up $dfile"
		fi
	done
	archive_backup
}

restore_backup() {
	# ask the user to select a backup to restore order by date

	backups=("$(ls -t "$BACKUP_ARCHIVE_DIR")")

	echo "Select a backup to restore:"

	for i in "${!backups[@]}"; do
		echo "[$i] ${backups[$i]}"
	done

	read -r -p "Enter the number of the backup to restore: " backup_num

	# check if the input is a number

	if ! [[ $backup_num =~ ^[0-9]+$ ]]; then
		echo "Invalid input: $backup_num"
		return
	fi

	# check if the input is within the range of the backups

	if [ "$backup_num" -lt 0 ] || [ "$backup_num" -ge ${#backups[@]} ]; then
		echo "Invalid input: $backup_num"
		return
	fi

	# extract the selected backup

	backup_file="$BACKUP_ARCHIVE_DIR/${backups[$backup_num]}"

	ar_status=$(tar -xzf "$backup_file" -C "$BACKUP_EXTRACTION_DIR")

	if [ "$ar_status" -ne 0 ]; then
		echo "Error: failed to extract backup"
		return
	fi

	# restore the dotfiles

	for dfile in "${DOTFILES[@]}"; do
		# Check if the dotfile exists in the backup
		if [ -e "$BACKUP_EXTRACTION_DIR/$dfile" ]; then
			# Restore the dotfile from the backup directory
			mv "$BACKUP_EXTRACTION_DIR/$dfile" "$HOME/$dfile"
			echo "Restored $dfile"
		fi
	done

	# clear the extract directory

	rm -rf "$BACKUP_EXTRACTION_DIR" && echo "Restored backup: ${backups[$backup_num]}"
}

restore_overwrt_backup() {
	# Restore overwritten dotfiles
	for dfile in "${OVERWRT_DOTFILES[@]}"; do
		# Restore the dotfile from the overwrite backup directory
		mv "$OVERWRT_BACKUP_DIR/$dfile" "$HOME/$dfile"
		echo "Restored $dfile"
	done
}

uninstall_dotfiles() {
	# Remove all symlinks to the dotfiles
	for dfile in "${DOTFILES[@]}"; do
		# Check if the dotfile exists
		if [ -e "$HOME/$dfile" ]; then
			# Remove the symlink
			rm "$HOME/$dfile"
			echo "Uninstalled $dfile"
		fi
	done
	restore_overwrt_backup
}

# Function to display help
show_help() {
	echo "Usage: $0 [install|uninstall|backup|help]"
	echo "  install   Install dotfiles (symlinks) , creating backups of existing files."
	echo "  uninstall Uninstall dotfiles, restoring backups if they exist."
	echo "  backup    Create a backup of existing dotfiles."
	echo "  list_backups    List all backups of existing dotfiles."
	echo "  restore_backup  Restore a backup of existing dotfiles."
	echo "  list_overwrite_backups    List all backups of overwritten dotfiles."
	echo "  remove_old_backups    Remove archive backups older than 30 days."
	echo "  help      Show this help message."
}

# Main function
main() {
	case "$1" in
	install)
		backup_dotfiles
		install_dotfiles
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
check_dirs
main "$@"
