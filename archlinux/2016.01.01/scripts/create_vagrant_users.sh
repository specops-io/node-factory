#!/bin/bash
SUDO="$(which sudo | grep -v 'not found')"

create_user() {
  username="$1"
  comment="$2"
  echo "creating user $username with comment $comment"
  $SUDO useradd -m -s /bin/bash -c "$comment" "$username"
}

add_user_to_sudo_nopass() {
  username="$1"
  echo "adding user $username to nopass sudo"
  $SUDO tee /etc/sudoers.d/$username << EOF
$username ALL=(ALL) NOPASSWD: ALL
EOF
}

create_user arch 'Archlinux Base User'
add_user_to_sudo_nopass arch

create_user vagrant 'Vagrant User'
add_user_to_sudo_nopass vagrant
