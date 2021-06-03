#!/usr/bin/env bash
#

DIR="$( cd "$( dirname "$0" )" && pwd )"

if [[ -f "$DIR/../publish/passwordhasher" ]]; then
	unlink "$DIR/../publish/passwordhasher"
fi

cp "$DIR/../bash/passwordhasher.sh" "$DIR/../publish/passwordhasher"
chmod +x "$DIR/../publish/passwordhasher"
#sudo chown root:root "$DIR/../publish/passwordhasher"
