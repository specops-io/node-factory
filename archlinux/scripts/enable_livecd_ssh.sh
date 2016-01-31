#!/bin/bash
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

echo -e "specops\nspecops" | passwd

$SUDO systemctl start sshd.service
