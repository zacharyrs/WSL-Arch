#!/bin/bash
set -ex

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

if [ $SUDO_USER ]; then
    real_user=$SUDO_USER
else
    real_user=$(whoami)
fi

# Get the current directory
BUILDIR=$(cd `dirname $0` && pwd -P)

# Prepare fakeroot-tcp as the normal (non-root) user
sudo -u $real_user sh <<EOF
# Get the current directory again...
BUILDIR=$(cd `dirname $0` && pwd -P)

# Get somewhere in tmp to work
TMPDIR=$(mktemp -d)
cd $TMPDIR

# Note you'll need the dependencies for this...
curl -LO "https://aur.archlinux.org/cgit/aur.git/snapshot/fakeroot-tcp.tar.gz"
tar xzf "fakeroot-tcp.tar.gz"
cd fakeroot-tcp
makepkg
cp "$(pwd)/$(ls | grep fakeroot | grep pkg)" "$BUILDDIR/fakeroot.pkg.gz"
EOF

# Embrace the root!
TMPDIR=$(mktemp -d)
cd $TMPDIR

# Get the base image
ARCH="x86_64"
VERSION="2019.09.01"
IMAGE="archlinux-bootstrap-$VERSION-$ARCH.tar.gz"
MIRROR="http://mirror.rackspace.com/archlinux/iso/$VERSION/$IMAGE"

curl -LO $MIRROR
tar xzf $IMAGE

# Stop us breaking things!
mount --bind root.${ARCH} root.${ARCH}
cd root.${ARCH}

# Set up internet and pacman configs...
cp /etc/resolv.conf etc/
cp $BUILDIR/linux/etc/pacman.conf etc/
cp $BUILDIR/linux/etc/pacman.d/mirrorlist etc/pacman.d/
sed -i -e 's/#en_US.UTF-8/en_US.UTF-8/' etc/locale.gen
echo "LANG=en_US.UTF-8" > etc/locale.conf
echo "LANGUAGE=en_US.UTF-8" >> /etc/locale.conf
echo "LC_ALL=en_US.UTF-8" >> /etc/locale.conf

# Copy over the fakeroot package
cp "$BUILDDIR/fakeroot.pkg.gz" tmp/

# Lets move to a new root!
mount -t proc /proc proc
mount --rbind /sys sys
mount --rbind /dev dev
mount --rbind /run run

#... and install stuff
chroot . pacman-key --init
chroot . pacman-key --populate archlinux
chroot . pacman -Syu --noconfirm
chroot . pacman -S --noconfirm sed base base-devel sudo ccache clang pigz pbzip2 git
yes | chroot . pacman -U --force /tmp/fakeroot.pkg.gz
yes | chroot . pacman -Scc
chroot . locale-gen

# Now to tidy up...
umount -l .

rm -rf tmp/*
rm -rf var/cache/pacman/pkg/*

# And make the final touches!
echo "# This file was automatically generated by WSL. To stop automatic generation of this file, remove this line." > etc/resolv.conf
cp -r $BUILDIR/linux/etc/* etc/
sed -i -e "s/^# %wheel ALL=.*NOPASSWD:.*$/%wheel ALL=(ALL) NOPASSWD: ALL/" etc/sudoers

tar --ignore-failed-read -czf ../install.tar.gz *

cp ../install.tar.gz $BUILDIR