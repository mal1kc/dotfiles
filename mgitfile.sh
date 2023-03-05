#!/bin/bash

DIRECTORY=~/.git
TARGT_DIR=~/.giti
GIGNOREFILE=~/.gitignore
TARGT_GIGNRF=~/.notgitignore

move_gitdir() {

	if [ -d "$DIRECTORY" ]; then
		# if $DIRECTORY exists
		mv $DIRECTORY $TARGT_DIR
	else
		if [ -d "$TARGT_DIR" ]; then
			mv $TARGT_DIR $DIRECTORY
		else
			echo $TARGT_DIR and $DIRECTORY not found
		fi
	fi
}

move_gignore() {

	if [ -f "$GIGNOREFILE" ]; then
		# if $DIRECTORY exists
		mv $GIGNOREFILE $TARGT_GIGNRF
	else
		if [ -f "$TARGT_GIGNRF" ]; then
			mv $TARGT_GIGNRF $GIGNOREFILE
		else
			echo $GIGNOREFILE and $TARGT_GIGNRF not found
		fi
	fi

}

move_gitdir
move_gignore
