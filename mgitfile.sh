#!/bin/bash

DIRECTORY=~/.git
TARGT_DIR=~/.giti

GIGNORE_F=~/.gitignore
TARGT_GIGNORE_F=~/.notgitignore

mv_gitdir() {
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

mv_gignore()
{

if [ -f "$GIGNORE_F" ]; then
  mv $GIGNORE_F $TARGT_GIGNORE_F
else
  if [ -f "$TARGT_GIGNORE_F" ]; then
    mv $TARGT_GIGNORE_F $GIGNORE_F
  else
   echo $TARGT_GIGNORE_F and $GIGNORE_F not found
  fi
fi

}

mv_gitdir
mv_gignore
