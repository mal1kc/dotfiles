#!/bin/bash

DIRECTORY=~/.git
TARGT_DIR=~/.giti

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
