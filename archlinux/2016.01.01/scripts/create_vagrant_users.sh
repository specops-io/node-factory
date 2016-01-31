#!/bin/bash

./archlinux/2016.01.01/scripts/create_user.sh arch 'Archlinux Base User'
./archlinux/2016.01.01/scripts/add_user_to_sudo_nopass.sh arch

./archlinux/2016.01.01/scripts/create_user.sh vagrant 'Vagrant User'
./archlinux/2016.01.01/scripts/add_user_to_sudo_nopass.sh vagrant
