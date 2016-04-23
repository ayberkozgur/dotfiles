my dotfiles
===========

Welcome to my dotfiles for Kubuntu 14.04.

To install:

```
git clone --recursive git@github.com:ayberkozgur/dotfiles.git ~/.dotfiles
~/.dotfiles/scripts/install.sh
```

This will symlink all dotfiles to your home directory. To clean these symlinks up:

```
~/.dotfiles/scripts/clean-symlinks.sh
```

Finally, to install (most of) the software packages I normally use:

```
~/.dotfiles/scripts/install-packages.sh
```

