#!/bin/bash

#Get script variables
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
BASEPATH=$(readlink -f "$SCRIPTPATH/../")
INITCMD="\e[0;94m$0\e[0m"
INITCMDERR="\e[0;31m$0\e[0m"

#Get -f argument
if [ "$1" == "-f" ]
then
    LNARG="-f"
fi

error_and_die(){
    >&2 echo -e $1
    exit 1
}

#Get all submodules
echo -e "$INITCMD: Getting submodules..."
git submodule update --init --recursive || exit 1
echo -e "$INITCMD: Getting submodules...done."

#Install vim runtime config
echo -e "$INITCMD: Installing ~/.vim/ ..."
SOURCEDIR=$(readlink -f "$BASEPATH/vim")
TARGETDIR="$HOME/.vim"
if [ -e "$TARGETDIR" ]
then
    if [ "$(readlink -f "$TARGETDIR")" == "$SOURCEDIR"  ]
    then
        echo -e "$INITCMD: ~/.vim/ is already installed, skipping."
    elif [ "$LNARG" == "-f" ]
    then
        rm -rf "$TARGETDIR"
        ln -s "$SOURCEDIR" "$TARGETDIR"
    else
        echo -e "$INITCMDERR: ~/.vim/ points to something else or not a symlink, not overwriting."
        error_and_die "$INITCMDERR: Installation failed; run as \`$0 -f\` to overwrite target files"
    fi
else
    ln -s "$SOURCEDIR" "$TARGETDIR"
fi
$HOME/.vim/install.sh $LNARG || exit 1
echo -e "$INITCMD: Installing ~/.vim/ ...done."

#Install all dotfiles as symlinks
echo -e "$INITCMD: Installing dotfiles..."
cd "$BASEPATH" && find . -type f -not -path "./vim/*" -not -path "./scripts/*" -not -path "./.git/*" -not -name ".gitignore" -not -name ".gitmodules" -not -name "README.md" | while read DOTFILE
do
    SOURCEFILE=$(readlink -f "$BASEPATH/$DOTFILE")
    TARGETFILE="$HOME/.${DOTFILE:2:${#DOTFILE}}"
    TARGETDIR=$(dirname "$TARGETFILE")

    echo -e "$INITCMD: Installing $SOURCEFILE to $TARGETFILE"
    mkdir -p "$TARGETDIR"
    ln -s $LNARG "$SOURCEFILE" "$TARGETFILE"

    #Check existence of the exact same link if we failed
    if [ "$?" -ne "0" ]
    then
        if [ "$(readlink -f "$TARGETFILE")" == "$SOURCEFILE"  ]
        then
            echo -e "$INITCMD: Target file is already installed, skipping."
        else
            echo -e "$INITCMDERR: Target file points to something else or not a symlink, not overwriting."
            error_and_die "$INITCMDERR: Installation failed; run as \`$0 -f\` to overwrite target files"
        fi
    fi
done
if [ "$?" -ne "0" ]; then exit 1; fi #The pipe in the loop introduces a subshell so we can't exit the whole script from inside the loop
echo -e $INITCMD": Installing dotfiles...done."

#Set up our bashrc
echo -e $INITCMD": Appending .mybashrc..."
if ! grep -Fxq "source ~/.mybashrc" ~/.bashrc
then
    echo -e "\nsource ~/.mybashrc\n" >> ~/.bashrc || exit 1
fi
echo -e $INITCMD": Appending .mybashrc...done."

#Mess with baloo
echo -e "$INITCMD: Locking baloo out..."
chmod 555 ~/.local/share/baloo || exit 1
echo -e "$INITCMD: Locking baloo out...done."

#Update font cache
echo -e "$INITCMD: Updating font cache..."
fc-cache -vf ~/.fonts/ || exit 1
echo -e "$INITCMD: Updating font cache...done."

echo -e "$INITCMD: Installation complete."

