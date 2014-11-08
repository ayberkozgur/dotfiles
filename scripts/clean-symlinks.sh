#!/bin/bash

#Color output
INITCMD="\e[0;94m$0\e[0m"

#Get necessary paths
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
BASEPATH=$(readlink -f "$SCRIPTPATH/../")

#Clean all symlinks
cd "$BASEPATH" && find . -type f -not -path "./scripts/*" -not -path "./.git/*" -not -name ".gitignore" -not -name ".gitmodules" -not -name "README.md" | while read DOTFILE
do
    SOURCEFILE=$(readlink -f "$BASEPATH/$DOTFILE")
    TARGETFILE="$HOME/dotfiles/.${DOTFILE:2:${#DOTFILE}}" # *************REMOVE dotfiles
    TARGETDIR=$(dirname "$TARGETFILE")

    if [ "$(readlink -f "$TARGETFILE")" == "$SOURCEFILE" ]
    then
        echo -e "$INITCMD: Removing target symlink $TARGETFILE"
        rm "$TARGETFILE"
        rmdir --ignore-fail-on-non-empty -p "$TARGETDIR"
    else
        echo -e "$INITCMD: Not removing target $TARGETFILE, points to something else, not a symlink or does not exist"
    fi
done

