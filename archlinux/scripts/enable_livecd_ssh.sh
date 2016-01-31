#!/bin/bash
PACMAN="$(which pacman) --quiet --noconfirm"
test `which sudo` || $PACMAN -S sudo
SUDO="$(which sudo)"

$SUDO useradd -m -s /bin/bash vagrant
echo -e "vagrant\nvagrant" | $SUDO passwd vagrant

$SUDO tee /etc/sudoers.d/vagrant << EOF
Defaults env_keep += "SSH_AUTH_SOCK"
vagrant ALL=(ALL) NOPASSWD: ALL
EOF


$SUDO systemctl start sshd.service
