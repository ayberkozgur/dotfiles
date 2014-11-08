my dotfiles
===========

Welcome to my dotfiles for Kubuntu 14.04.

To install:

```
git clone git@github.com:ayberkozgur/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && scripts/install.sh
```

This will symlink all dotfiles to your home directory. To clean these symlinks up:

```
cd ~/.dotfiles && scripts/clean-symlinks.sh
```

Finally, to install (most of) the software packages I normally use:

```
cd ~/.dotfiles && scripts/install-packages.sh
```

