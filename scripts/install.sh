#!/usr/bin/env bash
#
# Install scripts as executables, including local sqlite settings database.
# TODO: Installs from existing local checkout

if [ "$EUID" -ne 0 ]
  then echo "Root privileges missing."
  exit
fi

DIR="$( cd "$( dirname "$0" )" && pwd )"

cp "$DIR/../bash/passwordhasher.sh" /usr/local/bin/passwordhasher
cp "$DIR/../bash/pwhsettings.sh" /usr/local/bin/pwhsettings.sh
chown 0:0 /usr/local/bin/passwordhasher
chown 0:0 /usr/local/bin/pwdsettings.sh
chmod +rx /usr/local/bin/passwordhasher
chmod 0644 /usr/local/bin/pwhsettings.sh