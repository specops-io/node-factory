#!/bin/bash
SUDO="$(which sudo | grep -v 'not found')"

$SUDO tee --append /etc/ssh/sshd_config << EOF
PermitRootLogin yes
EOF

echo "specops\nspecops" | passwd

$SUDO systemctl start sshd.service
