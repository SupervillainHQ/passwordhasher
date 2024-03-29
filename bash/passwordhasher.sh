#!/usr/bin/env bash
#
# Create a string that can be used as a password, by combining a string with a secret string and hash it.
#
# Select a string and copy it into the clipboard (where cmd-c stores the marked text), then run this script.
# Input your secret when prompted, then the copied string is combined with your secret and the clipboard now contains
# your hash, ready for pasting into a password field.
# I usually select the domain from a website and copy that into the clipboard, so I can have a unique password for every
# website on which I have an account. I just need to remember the same secret.
#

DIR="$( cd "$( dirname "$0" )" && pwd )"

# yes, some places still require shorter passwords!
trunc(){
	hash=${hash:0:$1}
	#return $hash
}

# some passwords must contain upper-case characters
ucf(){
	hash=`echo $hash | perl -pe 's/([a-z])/\U$1/'`
}

# some passwords must contain special characters
spch(){
	res=""
	flag="0"
	for ((i=1;i<=${#hash};i++)); do
		char=${hash:$i-1:1}
		#echo "evaluating char $char"
		if [[ $char =~ ^[0-9]+$ ]] && [[ $flag -eq "0" ]]; then
			#echo "  transforming char $char"
			char=`echo $char | tr 0123456789 °!§#¥%@£ß∂`
			#echo "  to $char"
			flag="1"
		fi
		res="$res$char"
		char=""
	done

	hash=$res
}

read -s -p "salt: " salt
domain=`pbpaste`

hash=`echo -n "$domain$salt" | md5`

if [[ $# -eq 0 ]]; then
  # No args passed means that we should look for rules specific to the domain in the settings sqlite db
  savedArgs=`source "$DIR/pwhsettings.sh" get "$domain" $hash`
  IFS=' ' read -ra argz <<< "$savedArgs"

  for var in "${argz[@]}"
  do
    if [[ "$var" =~ ^[0-9]{2}$ ]]; then
      trunc $var
      #echo $hash
    fi

    if [[ "$var" = "ucf" ]]; then
      ucf
      #echo $hash
    fi

    if [[ "$var" = "spch" ]]; then
      spch
      #echo $hash
    fi
  done

else
  # Passing args means that we have been specified which rules to apply for transforming the hash. We should probably also
  # serialise these rules to the settings sqlite db.
  for var in "$@"
  do
    if [[ "$var" =~ ^[0-9]{2}$ ]]; then
      trunc $var
    fi

    if [[ "$var" = "ucf" ]]; then
      ucf
    fi

    if [[ "$var" = "spch" ]]; then
      spch
    fi
  done

  # Pass args and domain to db serialisation
  source "$DIR/pwhsettings.sh" add $domain $*
fi


echo -n "$hash" | pbcopy
