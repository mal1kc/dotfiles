#!/bin/env python
import json
import subprocess
import argparse
import os
from typing import Dict, Any, List


def execute_command(command: str) -> None:
    subprocess.Popen(command, shell=True)


def build_wofi_menu(
    options: List[Dict[str, Any]], script_pth: str | None = None
) -> None:
    # type check
    if not isinstance(options, list):
        raise TypeError("options must be a list")
    for option in options:
        if not isinstance(option, dict):
            raise TypeError("options must be a list of dictionaries")

    wofi_command = ["wofi", "-d", "-p", "Select an option:"]

    option_names = [option["name"] for option in options]

    wofi_output = subprocess.Popen(
        wofi_command,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    wofi_stdout, _ = wofi_output.communicate(input="\n".join(option_names))

    selected_option_name = wofi_stdout.strip()

    if not selected_option_name:
        return

    selected_option = next(
        (option for option in options if option["name"] == selected_option_name), None
    )

    if not selected_option:
        return

    if script_pth:
        execute_command(f"{script_pth} {selected_option['command']}")
    else:
        if "calculated_var" in selected_option:
            calculated_var = subprocess.check_output(
                selected_option["calculated_var"], shell=True, text=True
            ).strip()
            selected_option["calculated_var"] = calculated_var

        if "submenu" in selected_option:
            build_wofi_menu(selected_option["submenu"])
        elif (
            "dynamic_submenu" in selected_option and selected_option["dynamic_submenu"]
        ):
            submenu_command_output = subprocess.check_output(
                selected_option["dynamic_command"], shell=True, text=True
            ).strip()
            submenu_options = submenu_command_output.split("\n")
            build_wofi_menu([{"name": option} for option in submenu_options])
        elif "command" in selected_option:
            command = selected_option["command"].format(**selected_option)
            execute_command(command)


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Parse JSON file and display menu using wofi"
    )
    parser.add_argument("json", type=str, help="Path to the JSON file")
    args = parser.parse_args()

    possible_prefix = "~/.config/wofi/"
    # if file does not end with .json, assume it's in the wofi config folder and append .json
    if not args.json.endswith(".json"):
        args.json = os.path.join(possible_prefix, args.json + ".json")

    args.json = os.path.expanduser(args.json)

    if not os.path.exists(args.json):
        print(f"Error: File '{args.json}' not found.")
        return

    with open(args.json) as file:
        menu_data = json.load(file)

    if "globals" in menu_data:
        if "script" in menu_data["globals"]:
            script = menu_data["globals"]["script"]
            # if starts with ~,$HOME or $HOME expand it
            script_pth = os.path.expanduser(script)
            if not os.path.exists(script_pth):
                print(f"Error: Script '{script_pth}' not found.")
                return
            build_wofi_menu(menu_data["options"], script_pth)
    elif "options" in menu_data:
        build_wofi_menu(menu_data["options"])
    else:
        print("Error: No options found in JSON file.")
        exit(1)


if __name__ == "__main__":
    main()
