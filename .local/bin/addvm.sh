#!/usr/bin/env bash
#
# updated by: mal1kc
# # Project: virtual machine creation script, used with vmach.sh script or as stand alone installer | basen on Jake@linux's addvm.sh script

iso_files=$(ls ~/desktop/iso/*iso )

# Convert the list into an array
IFS=$'\n' read -d '' -ra files_array <<< "$files"

# Prompt user for index
echo "select a iso file by entering its index:"
for i in "${!files_array[@]}"; do
    echo "$i: ${files_array[$i]}"
done

read -p "enter the index: " index

# Validate the index
if [[ $index =~ ^[0-9]+$ ]] && ((index >= 0 && index < ${#files_array[@]})); then
    selected_file=${files_array[$index]}
    echo "selected file: $selected_file"
    # Do something with the selected file
    iso=$selected_file
    read -rep $'what distro?\n: ' distro
    read -rep $'how many CPUs?\n: ' cpu
    read -rep $'how much Mem?\n: ' mem


    read -rep $'disk size?\n: ' gb
    read -rep $'type of OS?\n: ' os
    read -rep $'bios or UEFI?\n: ' boot

    nohup virt-install --name="$distro" --vcpus="$cpu" --memory="$mem" --cdrom="~/desktop/iso/$iso" --disk size="$gb" --os-variant="$os" --boot "$boot" &
    read -r -p "press enter to continue" </dev/tty
    exit
else
    echo "invalid index."
    exit 1
fi

