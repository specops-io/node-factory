#!/bin/bash
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

echo "specops\nspecops" | passwd

$SUDO systemctl start sshd.service
