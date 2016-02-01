#!/bin/bash
SUDO="$(which sudo | grep -v 'not found')"

create_user() {
  username="$1"
  comment="$2"
  echo "creating group $username"
  $SUDO groupadd "$username"
  echo "creating user $username with comment $comment"
  $SUDO useradd -m --gid users --groups "$username" -s /bin/bash -c "$comment" "$username"
}

add_user_to_sudo_nopass() {
  username="$1"
  echo "adding user $username to nopass sudo"
  $SUDO tee /etc/sudoers.d/$username << EOF
Defaults env_keep += "SSH_AUTH_SOCK"
$username ALL=(ALL) NOPASSWD: ALL
EOF
  $SUDO chmod 0440 /etc/sudoers.d/$username
}

create_user arch 'Archlinux Base User'
add_user_to_sudo_nopass arch
