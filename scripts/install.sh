#!/bin/bash

#Get necessary paths
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
BASEPATH=$(readlink -f "$SCRIPTPATH/../")

#List all dotfiles
cd "$BASEPATH" && find . -type f -not -path "./scripts/*" | while read DOTFILE
do
    SOURCEFILE=$(readlink -f "$BASEPATH/$DOTFILE")
    TARGETFILE="$HOME/dotfiles/.${DOTFILE:2:${#DOTFILE}}" # *************REMOVE dotfiles
    TARGETDIR=$(dirname "$TARGETFILE")
    mkdir -p "$TARGETDIR"
    ln -s "$SOURCEFILE" "$TARGETFILE"
done

