#!/bin/bash
SUDO="$(which sudo | grep -v 'not found')"
USERNAME="$1"
COMMENT="$2"

create_user() {
  username="$1"
  comment="$2"
  echo "creating user $username with comment $comment"
  $SUDO useradd -m -s /bin/bash -c $comment $username
}

create_user $USERNAME $COMMENT
