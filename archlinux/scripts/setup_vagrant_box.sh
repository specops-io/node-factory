#!/bin/bash
# Vagrant-specific configuration
SUDO="$(which sudo | grep -v 'not found')"
PACMAN="${SUDO} $(which pacman) --quiet --noconfirm"
PASSWORD=$(/usr/bin/openssl passwd -crypt 'vagrant')

$SUDO groupadd vagrant
$SUDO usermod --password ${PASSWORD} --comment 'Vagrant User' --gid users --groups vagrant,vboxsf vagrant

$SUDO tee /etc/sudoers.d/vagrant << EOF
Defaults env_keep += "SSH_AUTH_SOCK"
vagrant ALL=(ALL) NOPASSWD: ALL
EOF

$SUDO chmod 0440 /etc/sudoers.d/vagrant
$SUDO install --directory --owner=vagrant --group=users --mode=0700 /home/vagrant/.ssh
$SUDO curl --output /home/vagrant/.ssh/authorized_keys --location https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
$SUDO chown vagrant:users /home/vagrant/.ssh/authorized_keys
$SUDO chmod 0600 /home/vagrant/.ssh/authorized_keys
