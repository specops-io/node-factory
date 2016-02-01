#!/bin/bash
SUDO="$(which sudo | grep -v 'not found')"
PACMAN="${SUDO} $(which pacman) --quiet --noconfirm"
guest_version="$($SUDO /usr/bin/pacman -Q virtualbox-guest-dkms | awk '{ print \$2 }' | cut -d'-' -f1)"
kernel_version="$($SUDO /usr/bin/pacman -Q linux | awk '{ print \$2 }')-ARCH"

# VirtualBox Guest Additions
$PACMAN -S linux-headers virtualbox-guest-utils virtualbox-guest-dkms nfs-utils

$SUDO tee /etc/modules-load.d/virtualbox.conf << EOF
vboxguest
vboxsf
vboxvideo
EOF

$SUDO dkms install "vboxguest/\${guest_version}" -k "\${kernel_version}/x86_64"
$SUDO systemctl enable dkms.service
$SUDO systemctl enable vboxservice.service
$SUDO systemctl enable rpcbind.service
