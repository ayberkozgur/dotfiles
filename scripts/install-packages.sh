#!/bin/bash

#Get script variables
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
INITCMD="\e[0;94m$0\e[0m"
PKGS=$(echo $(cat "$SCRIPTPATH/packages"))

#Install dependencies
echo -e "$INITCMD: Installing packages..."
apt-get install $PKGS || exit 1
echo -e "$INITCMD: Installing packages...done."

