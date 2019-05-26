#!/bin/bash
#

# INSTALL SECTION - should only be run at first provision/is not yet ready for multiple provision attempts

# avoid upgrading packages that requires interaction (the point of this bootstrap is to avoid interaction)
apt-mark hold grub-common grub-pc grub-pc-bin grub2-common
apt-mark hold kbd keyboard-configuration
apt-mark hold sudo

apt-get update
apt-get upgrade -y

locale-gen "en_US.UTF-8"

echo 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"' > /etc/environment
echo 'LC_ALL="en_US.UTF-8"' >> /etc/environment
echo 'LANG="en_US.UTF-8"' >> /etc/environment
echo 'LANGUAGE="en_US.UTF-8"' >> /etc/environment
echo 'LC_CTYPE="en_US.UTF-8"' >> /etc/environment
update-alternatives --set editor /usr/bin/vim.basic

#apt-get install -y curl vim wget git ntp python-software-properties python3-pip
apt-get install -y curl vim wget git ntp mercurial
apt-get install -y build-essential software-properties-common

apt-get update
# CONFIG SECTION - should be run at every provision

systemctl start ntp.service
# upgrade packages that requires interaction manually
apt-mark unhold grub-common grub-pc grub-pc-bin grub2-common
apt-mark unhold kbd keyboard-configuration
apt-mark unhold sudo

# TODO:
# How do we execute this as vagrant, not with sudo
# https://docs.npmjs.com/getting-started/fixing-npm-permissions
#
# update-alternatives --config editor