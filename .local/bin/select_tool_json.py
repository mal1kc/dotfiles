#!/bin/env python
import enum
import json
import subprocess
import argparse
import os
from typing import Protocol, override, Any


class select_tools(enum.Enum):
    wofi = enum.auto()
    fuzzel = enum.auto()


def execute_command(command: str) -> subprocess.Popen[bytes]:
    print(f"EXCUTE: {command}")
    return subprocess.Popen(command, shell=True)


class select_tool_protocol(Protocol):
    process_cmd: list[str]
    option_names: list[str]
    commands: list[str]
    process_outpt: subprocess.Popen[str]

    def __init__(self) -> None:
        return

    def build_menu(self, options: list[dict[str, Any]]):
        return

    def get_selection(self) -> str:
        # start procees and get input
        return ""


class tool_wofi(select_tool_protocol):
    process_cmd: list[str]
    option_names: list[str]
    commands: list[str]
    process_outpt: subprocess.Popen[str]

    def __init__(self) -> None:
        super().__init__()

    @override
    def build_menu(self, options: list[dict[str, Any]]):
        self.process_cmd = ["wofi", "-d", "-p", "Select an option:"]
        self.option_names = [option["name"] for option in options]

        self.process_outpt = subprocess.Popen(
            self.process_cmd,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
        return

    @override
    def get_selection(self) -> str:
        wofi_stdout, _ = self.process_outpt.communicate(
            input="\n".join(self.option_names)
        )
        return wofi_stdout.strip()


class tool_fuzzel(select_tool_protocol):
    process_cmd: list[str]
    option_names: list[str]
    commands: list[str]
    process_outpt: subprocess.Popen[str]

    def __init__(self) -> None:
        super().__init__()

    @override
    def build_menu(self, options: list[dict[str, Any]]):
        self.process_cmd = ["fuzzel", "--dmenu", "-p", "Select an option:"]
        self.option_names = [option["name"] for option in options]

        self.process_outpt = subprocess.Popen(
            self.process_cmd,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
        return

    @override
    def get_selection(self) -> str:
        fuzzel_stdout, _ = self.process_outpt.communicate(
            input="\n".join(self.option_names)
        )
        return fuzzel_stdout.strip()


def build_tool_menu(
    options: list[dict[str, Any]],
    script_pth: str | None = None,
    select_tool: select_tools = select_tools.fuzzel,
) -> None:
    # type check
    if not isinstance(options, list):
        raise TypeError("options must be a list")
    for option in options:
        if not isinstance(option, dict):
            raise TypeError("options must be a list of dictionaries")

    select_tool_helper: select_tool_protocol | None = None
    # print(f"{select_tool=}")
    if select_tool == select_tools.fuzzel:
        select_tool_helper = tool_fuzzel()
    else:
        select_tool_helper = tool_wofi()

    if select_tool_helper is None:
        print("ERROR: can't create select_tool_helper")
        return

    select_tool_helper.build_menu(options)
    selected_option_name = select_tool_helper.get_selection()
    # print(f"{selected_option_name=}")
    if not selected_option_name:
        return

    # print(f"{[option['name'] for option in options]}")

    selected_option = next(
        (option for option in options if option["name"] == selected_option_name), None
    )

    # print(f"{selected_option=}")
    if not selected_option:
        return
    if script_pth:
        _ = execute_command(f"{script_pth} {selected_option['command']}")
    else:
        if "calculated_var" in selected_option:
            calculated_var = subprocess.check_output(
                selected_option["calculated_var"], shell=True, text=True
            ).strip()
            selected_option["calculated_var"] = calculated_var

        if "submenu" in selected_option:
            build_tool_menu(selected_option["submenu"], script_pth, select_tool)
        elif (
            "dynamic_submenu" in selected_option and selected_option["dynamic_submenu"]
        ):
            submenu_command_output = subprocess.check_output(
                selected_option["dynamic_command"], shell=True, text=True
            ).strip()
            submenu_options = submenu_command_output.split("\n")
            build_tool_menu(
                [{"name": option} for option in submenu_options],
                script_pth,
                select_tool,
            )
        elif "command" in selected_option:
            command = selected_option["command"].format(**selected_option)
            _ = execute_command(command)


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Parse JSON file and display menu using wofi"
    )
    _ = parser.add_argument("json", type=str, help="Path to the JSON file")
    args = parser.parse_args()

    select_tool_selection = select_tools.fuzzel

    config_prefix = "~/.config/selection_tool/"
    # if file does not end with .json, assume it's in the wofi config folder and append .json
    if not args.json.endswith(".json"):
        args.json = os.path.join(config_prefix, args.json + ".json")

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
            build_tool_menu(
                menu_data["options"], script_pth, select_tool=select_tool_selection
            )
    elif "options" in menu_data:
        build_tool_menu(menu_data["options"], select_tool=select_tool_selection)
    else:
        print("Error: No options found in JSON file.")
        exit(1)


if __name__ == "__main__":
    main()
