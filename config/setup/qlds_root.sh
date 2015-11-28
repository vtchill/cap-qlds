#!/bin/bash
# qulds_root.sh - quake live dedicated server installation for root user.
# intended to be run on a fresh VPS/Dedicated Server, this script must be run under the root user.
# created by Thomas Jones on 29/09/15.
# Edited by Jesse Manning 07/11/215.

export QLDS_USER="steam"

if [ "$EUID" -ne 0 ]
  then echo "Please run under user 'root'."
  exit
fi
echo "Updating 'apt-get'..."
apt-get update

echo "Installing packages..."
apt-get -y install python3 python-setuptools lib32gcc1 curl build-essential python-dev unzip wget lib32z1 lib32stdc++6 libc6

echo "Adding user $QLDS_USER..."
useradd -m $QLDS_USER
usermod -a -G sudo $QLDS_USER
chsh -s /bin/bash $QLDS_USER

echo "Enter the password to use for $QLDS_USER account:"
passwd $QLDS_USER

echo "Adding user '$QLDS_USER' to sudoers file, and appending NOPASSWD..."
echo "$QLDS_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

echo "Installing Supervisor..."
easy_install supervisor

echo "All work done for 'root' user, please login with $QLDS_USER user account."
exit
