#!/bin/bash
PACMAN="$(which sudo | grep -v 'not found') $(which pacman) --quiet --noconfirm"
NAME=$1

sudo $PACMAN -Sc

test ! -d /var/lib/cloud || sudo rm -rf /var/lib/cloud/*

sudo bash -c "echo \"${NAME} - built with packer\" > /etc/build.info"
