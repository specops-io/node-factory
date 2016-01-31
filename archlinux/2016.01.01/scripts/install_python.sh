#!/bin/bash
SUDO="$(which sudo | grep -v 'not found')"
PACMAN="${SUDO} $(which pacman) --quiet --noconfirm"

$PACMAN -S python2 python2-pip python2-dev
