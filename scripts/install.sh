#!/bin/bash

error_and_die(){
     >&2 echo $1
     exit 1
}

#Get necessary paths
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
BASEPATH=$(readlink -f "$SCRIPTPATH/../")

#Get -f argument
if [ "$1" == "-f" ]
then
    LNARG="-f"
fi

#Install all dotfiles as symlinks
echo "$0: Installing dotfiles..."
cd "$BASEPATH" && find . -type f -not -path "./scripts/*" -not -path "./.git/*" -not -name ".gitignore" -not -name ".gitmodules" | while read DOTFILE
do
    SOURCEFILE=$(readlink -f "$BASEPATH/$DOTFILE")
    TARGETFILE="$HOME/dotfiles/.${DOTFILE:2:${#DOTFILE}}" # *************REMOVE dotfiles
    TARGETDIR=$(dirname "$TARGETFILE")

    echo "$0: Installing $SOURCEFILE to $TARGETFILE"
    mkdir -p "$TARGETDIR"
    ln -s $LNARG "$SOURCEFILE" "$TARGETFILE" || error_and_die "$0: Installation failed; run as \`$0 -f\` to overwrite target files"
done
if [ "$?" -ne "0" ]; then exit 1; fi #The pipe in the loop introduces a subshell so we can't exit the whole script from inside the loop
echo $0": Installing dotfiles...done."

#Set up our bashrc


#Mess with baloo
echo "$0: Locking baloo out..."
chmod 555 ~/.local/share/baloo || exit 1
echo "$0: Locking baloo out...done."

#Update font cache
echo "$0: Updating font cache..."
fc-cache -vf ~/.fonts/ || exit 1
echo "$0: Updating font cache...done."
