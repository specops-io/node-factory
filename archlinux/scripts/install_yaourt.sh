#!/bin/bash
SUDO="$(which sudo | grep -v 'not found')"
PACMAN="${SUDO} $(which pacman) --quiet --noconfirm"

install_aur_package() {
  package=$1
  repo=$2
  echo "installing $package from $repo"
  $SUDO su -l -c "git clone $repo /tmp/$package" arch
  $SUDO su -l -c "cd /tmp/$package ; makepkg -sri --noconfirm" arch
  $SUDO su -l -c "rm -rf /tmp/$package" arch
}

$PACMAN -S --needed curl git base-devel

install_aur_package "package-query" "https://aur.archlinux.org/package-query.git"
install_aur_package "yaourt" "https://aur.archlinux.org/yaourt"
