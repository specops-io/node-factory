#!/bin/bash
SUDO="$(which sudo | grep -v 'not found')"
PACMAN="${SUDO} $(which pacman) --quiet --noconfirm"

$PACMAN -Syy --needed sudo

$SUDO tee /etc/sudoers << EOF
root ALL=(ALL) ALL
arch ALL=(ALL) NOPASSWD: ALL

## Read drop-in files from /etc/sudoers.d
## (the '#' here does not indicate a comment)
#includedir /etc/sudoers.d
EOF

$SUDO useradd -m -s /bin/bash -c 'Arch Package Builder User' arch
