#!/bin/bash

error_and_die(){
     >&2 echo -e $1
     exit 1
}

#Color output
INITCMD="\e[0;94m$0\e[0m"

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
echo -e "$INITCMD: Installing dotfiles..."
cd "$BASEPATH" && find . -type f -not -path "./scripts/*" -not -path "./.git/*" -not -name ".gitignore" -not -name ".gitmodules" -not -name "README.md" | while read DOTFILE
do
    SOURCEFILE=$(readlink -f "$BASEPATH/$DOTFILE")
    TARGETFILE="$HOME/dotfiles/.${DOTFILE:2:${#DOTFILE}}" # *************REMOVE dotfiles
    TARGETDIR=$(dirname "$TARGETFILE")

    echo -e "$INITCMD: Installing $SOURCEFILE to $TARGETFILE"
    mkdir -p "$TARGETDIR"
    ln -s $LNARG "$SOURCEFILE" "$TARGETFILE" || error_and_die "$INITCMD: Installation failed; run as \`$0 -f\` to overwrite target files"
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
