#!/usr/bin/env bash
#rismasystems.com
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
  for var in "$@"
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
fi


echo -n "$hash" | pbcopy
