#!/bin/bash
SUDO="$(which sudo | grep -v 'not found')"
USERNAME="$1"

add_user_to_sudo_nopass() {
  username="$1"
  echo "adding user $username to nopass sudo"
  $SUDO tee /etc/sudoers.d/$username << EOF
$username ALL=(ALL) NOPASSWD: ALL
EOF
}

add_user_to_sudo_nopass $USERNAME
