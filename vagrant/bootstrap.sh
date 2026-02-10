#!/usr/bin/env bash
#

update-alternatives --set editor /usr/bin/vim.basic

# Install stuff
apt-get update
apt-get upgrade -y

add-apt-repository -y ppa:ondrej/php
apt-get update

apt-get install -y php8.1 php8.1-psr php8.1-xdebug php8.1-cli php8.1-curl php8.1-gd php8.1-intl php8.1-mbstring php8.1-xml php8.1-xsl

# current (2026-01) composer version requires and installs newer php version
apt-get install -y composer

# v10 supports php8.1
wget https://phar.phpunit.de/phpunit-10.phar -O /usr/local/bin/phpunit
chown root:root /usr/local/bin/phpunit
chmod +x /usr/local/bin/phpunit


# Config
# Move the ini files if this is the first boot, in order to have a ini file that can record
# important php configurations
#mv /etc/php/8.1/cli/php.ini php8.1-cli.ini
unlink /etc/php/8.1/cli/php.ini
ln -fs /vagrant/php8.1-cli.ini /etc/php/8.1/cli/php.ini

