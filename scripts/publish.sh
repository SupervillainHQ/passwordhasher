#!/usr/bin/env bash
#
# Create a folder that can be distributed

if [ "$EUID" -ne 0 ]
  then echo "Root privileges missing."
  exit
fi

DIR="$( cd "$( dirname "$0" )" && pwd )"

if [[ -f "$DIR/../publish/passwordhasher" ]]; then
	unlink "$DIR/../publish/passwordhasher"
fi
if [[ -f "$DIR/../publish/pwhsettings.sh" ]]; then
	unlink "$DIR/../publish/pwhsettings.sh"
fi
if [[ -f "$DIR/../publish/passwordhasher.tgz" ]]; then
	unlink "$DIR/../publish/passwordhasher.tgz"
fi

cp "$DIR/../bash/passwordhasher.sh" "$DIR/../publish/passwordhasher"
cp "$DIR/../bash/pwhsettings.sh" "$DIR/../publish/pwhsettings.sh"
chmod +rx "$DIR/../publish/passwordhasher"
chown 0:0 "$DIR/../publish/passwordhasher"
chmod 0644 "$DIR/../publish/pwhsettings.sh"
chown 0:0 "$DIR/../publish/pwhsettings.sh"

cd "$DIR/../publish/"
tar -cf passwordhasher.tgz passwordhasher pwhsettings.sh
unlink "$DIR/../publish/passwordhasher"
unlink "$DIR/../publish/pwhsettings.sh"
