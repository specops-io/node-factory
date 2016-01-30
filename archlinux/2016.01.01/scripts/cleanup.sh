#!/bin/bash
PACMAN="$(which sudo | grep -v 'not found') $(which pacman) --quiet --noconfirm"

test ! -d /var/lib/cloud || sudo rm -rf /var/lib/cloud/*
sudo $PACMAN -Sc
sudo $PACMAN -Rns $($PACMAN -Qtdq)
sudo bash -c "echo \"${ATLAS_BUILD_SLUG}:${ATLAS_BUILD_GITHUB_COMMIT_SHA} - built with packer\" > /etc/build.info"
