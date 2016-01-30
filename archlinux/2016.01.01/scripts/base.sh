#!/bin/bash
SUDO="$(which sudo | grep -v 'not found')"
PACMAN="${SUDO} $(which pacman) --quiet --noconfirm"

$PACMAN -Syy archlinux-keyring
$PACMAN -Syyu
$SUDO pacman-db-upgrade
