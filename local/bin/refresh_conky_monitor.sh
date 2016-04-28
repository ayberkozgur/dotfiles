#!/bin/bash
pkill -f "conkymonitorrc"
conky -c ~/.local/etc/conkymonitorrc
