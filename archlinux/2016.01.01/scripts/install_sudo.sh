#!/bin/bash
SUDO="$(which sudo | grep -v 'not found')"
PACMAN="${SUDO} $(which pacman) --quiet --noconfirm"

$PACMAN -Syy --needed sudo

$SUDO tee /etc/sudoers << EOF
root ALL=(ALL) ALL

## Read drop-in files from /etc/sudoers.d
## (the '#' here does not indicate a comment)
#includedir /etc/sudoers.d
EOF
