#!/usr/bin/env bash

DISK='/dev/sda'
FQDN='vagrant-arch.vagrantup.com'
KEYMAP='us'
LANGUAGE='en_US.UTF-8'
TIMEZONE='UTC'

CONFIG_SCRIPT='/usr/local/bin/arch-config.sh'
ROOT_PARTITION="${DISK}1"
TARGET_DIR='/mnt'
SUDO="$(which sudo | grep -v 'not found')"

echo "==> clearing partition table on ${DISK}"
$SUDO /usr/bin/sgdisk --zap ${DISK}

echo "==> destroying magic strings and signatures on ${DISK}"
$SUDO /usr/bin/dd if=/dev/zero of=${DISK} bs=512 count=2048
$SUDO /usr/bin/wipefs --all ${DISK}

echo "==> creating /root partition on ${DISK}"
$SUDO /usr/bin/sgdisk --new=1:0:0 ${DISK}

echo "==> setting ${DISK} bootable"
$SUDO /usr/bin/sgdisk ${DISK} --attributes=1:set:2

echo '==> creating /root filesystem (ext4)'
$SUDO /usr/bin/mkfs.ext4 -F -m 0 -q -L root ${ROOT_PARTITION}

echo "==> mounting ${ROOT_PARTITION} to ${TARGET_DIR}"
$SUDO /usr/bin/mount -o noatime,errors=remount-ro ${ROOT_PARTITION} ${TARGET_DIR}

echo '==> bootstrapping the base installation'
$SUDO /usr/bin/pacstrap ${TARGET_DIR} base
$SUDO /usr/bin/arch-chroot ${TARGET_DIR} pacman -S --noconfirm gptfdisk openssh syslinux sudo
$SUDO /usr/bin/arch-chroot ${TARGET_DIR} syslinux-install_update -i -a -m
$SUDO /usr/bin/sed -i 's/sda3/sda1/' "${TARGET_DIR}/boot/syslinux/syslinux.cfg"
$SUDO /usr/bin/sed -i 's/TIMEOUT 50/TIMEOUT 10/' "${TARGET_DIR}/boot/syslinux/syslinux.cfg"

echo '==> generating the filesystem table'
$SUDO /usr/bin/genfstab -p ${TARGET_DIR} >> "${TARGET_DIR}/etc/fstab"

echo '==> generating the system configuration script'
$SUDO /usr/bin/install --mode=0755 /dev/null "${TARGET_DIR}${CONFIG_SCRIPT}"

cat <<-EOF > "${TARGET_DIR}${CONFIG_SCRIPT}"
  echo '${FQDN}' > /etc/hostname
  /usr/bin/ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
  echo 'KEYMAP=${KEYMAP}' > /etc/vconsole.conf
  /usr/bin/sed -i 's/#${LANGUAGE}/${LANGUAGE}/' /etc/locale.gen
  /usr/bin/locale-gen
  /usr/bin/mkinitcpio -p linux
  # https://wiki.archlinux.org/index.php/Network_Configuration#Device_names
  /usr/bin/ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules
  /usr/bin/ln -s '/usr/lib/systemd/system/dhcpcd@.service' '/etc/systemd/system/multi-user.target.wants/dhcpcd@eth0.service'
  /usr/bin/sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
  /usr/bin/systemctl enable sshd.service

  # clean up
  /usr/bin/pacman -Rcns --noconfirm gptfdisk
  /usr/bin/yes | /usr/bin/pacman -Scc
EOF

echo '==> entering chroot and configuring system'
$SUDO /usr/bin/arch-chroot ${TARGET_DIR} ${CONFIG_SCRIPT}
$SUDO rm "${TARGET_DIR}${CONFIG_SCRIPT}"

# http://comments.gmane.org/gmane.linux.arch.general/48739
echo '==> adding workaround for shutdown race condition'
cat << EOF > poweroff.timer
[Unit]
Description=Delayed poweroff

[Timer]
OnActiveSec=1
Unit=poweroff.target
EOF
$SUDO /usr/bin/install --mode=0644 poweroff.timer "${TARGET_DIR}/etc/systemd/system/poweroff.timer"

echo '==> installation complete!'
$SUDO /usr/bin/sleep 3
$SUDO /usr/bin/umount ${TARGET_DIR}
$SUDO /usr/bin/systemctl reboot
