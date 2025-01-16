#!/usr/bin/env python
# """BSD 3-Clause License
#
# Copyright (c) 2024-2026, mal1kc
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."""
# this script's main functionality can be achieven with gnu stow
# but still writed this script because i don't understand perl
#
# this script has this features
# - dotfiles location is hardcoded as $HOME/dotfiles
# - has abilitiy to with verbose toggle (-v or --verbose) also has abilitiy to show change diff (--diff)
# - has abilitiy to run in dry mode (--dry)
#
# - if crash or die while creating symlinks non tar backups can be located uner /tmp with some rundtime defined folder
#
# - it will modify home folders listed in DOTFILE_LIST and not in IGNORE_FILES
#
# - in nondry run:
#    - will create recursive symlinks files based of hardcoded directory of files : you can edit it via DOTFILE_LIST constant
#    - will create a backup tar file of replaced files for last 3 runs (oldest is higher num) under dotfiles dir
#    - will create log file of  excuted operations dotfiles_installer.log at dotfiles dir
#
import argparse
import os
import shutil
import sys
import tempfile
import logging
from pathlib import Path
from typing import Callable

# from difflib import Differ

HOME_DIR: Path = Path.home()

DOTFILES_DIR: Path = HOME_DIR.joinpath("dotfiles")
LOGFILE: Path = DOTFILES_DIR.joinpath("dotfiles_installer.log")
BACKUPS_DIR: Path = DOTFILES_DIR.joinpath(".dotfiles_backups")
BACKUP_TAR_BASE_NAME = "dotfiles_bckp"
BACKUP_MAX_LMT = 3
BACKUP_TAR_FILE_FORMAT = ("tar.gz", "gztar")

BACKUP_TMP_DIR: tempfile.TemporaryDirectory = (
    tempfile.TemporaryDirectory()
)  # for creating tar_file

# logging.basicConfig(
#     level=logging.INFO,  # non-verbose
#     # level=logging.DEBUG,  # verbose
#     format="%(asctime)s - %(levelname)s - %(message)s",  # Log message format
#     filename=LOGFILE.absolute(),
#     filemode="w",  # Overwrite the log file each time the script runs
# )

LOGGER = logging.Logger("main")
LOGGER.setLevel(logging.INFO)
LOGGER.addHandler(logging.FileHandler(LOGFILE.absolute(), "w", "utf-8"))
assert LOGGER.hasHandlers()
LOGGER.handlers[0].formatter = logging.Formatter(
    "%(asctime)s - %(levelname)s - %(message)s"
)


DOTFILE_LIST: list[Path] = [
    Path(config)
    for config in [
        ".local/bin",
        ".local/share/applications",
        ".Xresources",
        ".bashrc",
        ".gitconfig",
        ".inputrc",
        ".zshrc",
    ]
]


IGNORE_FILES: list[Path] = [
    Path(ignr_config)
    for ignr_config in [
        str(BACKUPS_DIR),
        str(LOGFILE),
        ".git",
        ".gitignore",
        ".gitmodules",
        ".firefox_scripts_configs",
        ".pre-commit-config.yaml",
        "scripts",
        "dotfiles_installers",
        "pkg_list.txt",
        "nix_profile_pkg_list.txt",
        "install.py",
        "readme.org",
    ]
]


class global_options:
    dry_run: bool = True
    verbose: bool = False
    do_backup: bool = True
    exit_on_err: bool = True
    dotfiles: list[Path] = [
        dfile for dfile in DOTFILE_LIST if dfile not in IGNORE_FILES
    ]


OTHER_DOTFILES: dict[str, list[Path]] = {
    "x11": [
        Path(x11config)
        for x11config in [
            ".xinitrc",
            ".xprofile",
            # ".config/picom.conf",
            # ".config/rofi",
            ".config/i3",
        ]
    ],
    "wayland": [
        Path(waylandconfig)
        for waylandconfig in [
            ".config/foot",
            ".config/hypr",
            ".config/river",
            ".config/waybar",
            # ".config/wofi",
            ".config/fuzzel",
        ]
    ],
}


def mkdirs(fpath: str | Path) -> None:
    if isinstance(fpath, Path):
        fpath.mkdir(parents=True)
    elif isinstance(fpath, str):
        fpath_p = Path(fpath)
        fpath_p.mkdir(parents=True)
    else:
        LOGGER.debug(f"Missuse of mkdirs with {fpath}")
        exit(1)


def reorder_old_backup_files() -> None:
    glob_ptrn = f"*.[0-9].{BACKUP_TAR_FILE_FORMAT[0]}"
    LOGGER.debug("backup: globbing old backups files.")
    childs = [ch for ch in BACKUPS_DIR.glob(glob_ptrn)]
    LOGGER.debug(f"backup: found {len(childs)} old backup files.")
    childs.sort()
    new_childs = []
    if len(childs) >= BACKUP_MAX_LMT:
        last_backup_file = childs.pop()
        LOGGER.debug(
            f"backup: remove oldest backup file {last_backup_file.absolute()}."
        )
        if not global_options.dry_run:
            os.remove(last_backup_file.absolute())

    for indx, ch in enumerate(childs):
        # change last part 1.tar.gz => 2.tar.gz

        new_ch_name = ch.parent.joinpath(
            ch.name[: -{3 + len(BACKUP_TAR_FILE_FORMAT[0])}] + str(indx + 2)
        ).absolute()
        # absolute is necessary for rename in correct parent dir
        # +2 because 0. index has 1 suffix, 1. index has 2 suffix
        if not global_options.dry_run:
            new_ch = ch.rename(new_ch_name)
            assert (
                new_ch != ch
            ), "Panic!: iterative move of old backups has a bug with renaming."
            assert (
                new_ch.parent == ch.parent
            ), "Panic!: iterative move of old backups has directory bug."
            new_childs.append(new_ch)
        LOGGER.debug(f"backup: mov old backup {ch} to {new_ch_name}")
    if len(childs) > 0:
        assert (
            childs[0].absolute() != new_childs[0].absolute()
        ), "Panic!: iterative move of old backups has a bug probably."


def create_archive(
    dir_to_archive: Path,
) -> Path:
    """
    Create a archive of files.
    """
    reorder_old_backup_files()
    backup_file_name = BACKUP_TAR_BASE_NAME + ".1"
    LOGGER.info(f"backup: backup tar creating at '{BACKUPS_DIR}' .")
    BACKUPS_DIR.mkdir(exist_ok=True)
    archive_res = shutil.make_archive(
        base_name=backup_file_name,
        format=BACKUP_TAR_FILE_FORMAT[1],
        root_dir=BACKUPS_DIR.absolute(),
        base_dir=dir_to_archive,
        dry_run=global_options.dry_run,
    )
    dst_path = BACKUPS_DIR.joinpath(backup_file_name + "." + BACKUP_TAR_FILE_FORMAT[0])
    LOGGER.info(f"backup: backup tar created at {archive_res}.")
    os.rename(archive_res, dst_path)
    LOGGER.info(f"backup: backup tar moved to {dst_path}.")
    return dst_path


def move_to_backup_dir(dotfile: Path):
    """
    - dfile must be relative_to HOME_DIR
    - move current dotfile to BACKUPS_DIR
    """
    tmp_dir = Path(BACKUP_TMP_DIR.name)
    assert (
        tmp_dir.exists() and tmp_dir.is_dir()
    ), f"{BACKUP_TMP_DIR=} must be exists and must be dir"
    #  must be in this format : .config/hypr/hyprland.conf
    #  not in this format : /home/mal1kc/.config/hypr/hyprland.conf
    assert (
        HOME_DIR not in dotfile.parents
    ), f"{dotfile=} must be relative_to {HOME_DIR=}"

    LOGGER.info(f"move_to_backup_dir: backuping {dotfile.absolute()}")
    dst = Path(BACKUP_TMP_DIR.name).joinpath(dotfile)
    src = HOME_DIR.joinpath(dotfile)
    if not src.exists():
        LOGGER.info(f"move_to_backup_dir: {src} not exits not doing backup for {src}")
        return

    assert src.exists(
        follow_symlinks=False
    ), "src must be existsed on move_to_backup_dir"
    assert src.is_file(), "src must be file on move_to_backup_dir"

    assert not dst.exists(
        follow_symlinks=False
    ), f"{dst=} must be not existed on move_to_backup_dir"
    LOGGER.info(f"move_to_backup_dir: {src} backed up as {dst}")
    if not global_options.dry_run:
        if not dst.parent.exists():
            LOGGER.debug(f"move_to_backup_dir: {dst.parent} not exists creating dir")
            dst.parent.mkdir(parents=True, exist_ok=True)
        assert (
            dst.parent.exists()
        ), f"{dst.parent} must be existed on move_to_backup_dir"
        shutil.move(src.absolute(), dst.absolute())
        assert dst.exists(
            follow_symlinks=False
        ), "after a move of src , dst must be existed on move_to_backup_dir"


def install_dotfile(dfile: Path) -> bool:
    """
    - This is recursive for folders
    - Install a dotfile (symlink) if file exists on symlinked location move that file to BACKUP_TMP_DIR
    """
    src = DOTFILES_DIR.joinpath(dfile)
    dst = HOME_DIR.joinpath(dfile)

    LOGGER.debug(f"install_dotfile: {src.absolute()} to {dst.absolute()}")

    # -- checks_start
    if not src.exists(follow_symlinks=False):
        LOGGER.error(f"install_dotfile: {src} not exists")
        return False

    if dst.exists(follow_symlinks=False):
        if not dst.is_symlink():
            if dst.is_dir():
                for subfile in dst.iterdir():
                    if not install_dotfile(subfile.relative_to(HOME_DIR)):
                        LOGGER.error(
                            "install_dotfile: failed install_dotfile",
                            subfile.relative_to(HOME_DIR),
                        )
            else:
                if global_options().do_backup:
                    move_to_backup_dir(dst.relative_to(HOME_DIR))
                else:
                    logging.debug(f"install_dotfile: removing {dst.absolute()}")
                    if not global_options.dry_run:
                        os.remove(dst.absolute())
                assert not dst.exists(
                    follow_symlinks=False
                ), f"{dst=} needs be not exists anymore."
        else:
            LOGGER.debug(
                f"install_dotfile: found a symlink at {dst.absolute()} unlinking it."
            )
            if not global_options.dry_run:
                os.unlink(dst.absolute())
            assert not dst.exists(
                follow_symlinks=False
            ), f"{dst=} needs be not exists anymore."
    if src.is_dir():
        LOGGER.info(
            f"install_dotfile: {src=} is directory creating dir at destination."
        )
        if not global_options.dry_run:
            dst.mkdir(parents=True, exist_ok=True)
            assert dst.is_dir(), "directory must be created"
        for subfile in src.iterdir():
            if not install_dotfile(subfile.relative_to(DOTFILES_DIR)):
                LOGGER.error(
                    "install_dotfile: failed install_dotfile",
                    subfile.relative_to(HOME_DIR),
                )
        return True

    # -- checks_end
    LOGGER.info(f"install_dotfile: linkink files {src.absolute()}  {dst.absolute()} ")
    if not global_options.dry_run:
        os.symlink(src, dst)
        assert dst.is_symlink(), "dst must be symlink"
    return True


def cli_install_dotfiles() -> None:
    """
    Install dotfiles
    """
    for dfile in global_options.dotfiles:
        if not install_dotfile(dfile):
            LOGGER.debug(f"cli_uninstall_dotfiles: can't install {dfile.absolute()}")

    dir_to_archive = Path(BACKUP_TMP_DIR.name)
    assert dir_to_archive.is_dir(), "dir_to_archive must be dir"
    assert dir_to_archive.is_absolute(), "dir_to_archive must be absolute"
    if global_options.do_backup:
        archive_file = create_archive(dir_to_archive)
        LOGGER.debug(f"cli_install_dotfiles: create_archive returned {archive_file=}")
        assert archive_file.exists(
            follow_symlinks=False
        ), "backup: can't created backup tar file"
    BACKUP_TMP_DIR.cleanup()


def cli_check_exists() -> None:
    """
    give state about non-existed dotfiles and already existed files
    """
    for dfile in global_options.dotfiles:
        if not DOTFILES_DIR.joinpath(dfile).exists(follow_symlinks=False):
            LOGGER.error(f"cli_check_exists: {dfile} not exists")
            continue
        LOGGER.info(f"cli_check_exists: {dfile} exists")


def get_actions() -> list[dict[str, str | (Callable[..., None]) | dict[str, bool]]]:
    return [
        {
            "name": "install",
            "help": "Install dotfiles and scripts.",
            "func": cli_install_dotfiles,
            "args": {},
        },
        {
            "name": "check_exists",
            "help": "give state about non-existed dotfiles and already existed files",
            "func": cli_check_exists,
            "args": {},
        },
    ]


def main() -> None:
    parser = argparse.ArgumentParser(description="Install dotfiles.")
    _ = parser.add_argument(
        "action",
        choices=[action["name"] for action in get_actions()],
        help="Action to perform.",
    )
    _ = parser.add_argument(
        "--x11",
        action="store_true",
        help="include X11 related dotfiles to dotfiles_list",
    )

    _ = parser.add_argument(
        "--wayland",
        action="store_true",
        help="include Wayland related dotfiles to dotfiles_list",
    )
    _ = parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Do not perform desctructive (delete,move) action .Just print what would be done.CAN BE FAIL",
    )
    _ = parser.add_argument(
        "--verbose",
        action="store_true",
        help="Print more information.",
    )

    args = parser.parse_args()

    if not args.dry_run:  # pyright: ignore[reportAny]
        global_options.dry_run = False
    if args.verbose:  # pyright: ignore[reportAny]
        global_options.verbose = True
        LOGGER.setLevel(logging.DEBUG)
        LOGGER.addHandler(logging.StreamHandler(sys.stderr))  # sys.stderr

    if args.x11:  # pyright: ignore[reportAny]
        global_options.dotfiles += OTHER_DOTFILES["x11"]
    if args.wayland:  # pyright: ignore[reportAny]
        global_options.dotfiles += OTHER_DOTFILES["wayland"]

    action = next(
        (action for action in get_actions() if action["name"] == args.action),  # pyright: ignore[reportAny]
        None,
    )
    if action:
        action["func"](**action["args"])  # type: ignore
    else:
        LOGGER.error(f"main: Action {args.action} not found.")  # pyright: ignore[reportAny]

    sys.exit(0)


if __name__ == "__main__":
    main()  # pyright: ignore[reportUnreachable]
