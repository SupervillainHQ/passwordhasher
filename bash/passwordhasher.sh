#!/usr/bin/env bash
#rismasystems.com
#
DIR="$( cd "$( dirname "$0" )" && pwd )"

# yes, some places still require shorter passwords!
trunc(){
	echo "truncate to len: $1"
	hash=${hash:0:$1}
	#return $hash
}

# some passwords must contain upper-case characters
ucf(){
	echo "first char upper-case"
	hash=`echo $hash | perl -pe 's/([a-z])/\U$1/'`
}

# some passwords must contain special characters
spch(){
	echo "replace first number with special chars"

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
  echo "fetch rules from pwh.db"
  savedArgs=`source "$DIR/pwhsettings.sh" get "$domain" $hash`
#  echo $savedArgs
  IFS=' ' read -ra argz <<< "$savedArgs"

  echo "saved args:"
  echo ${#argz[@]}
#  rules="${rulesArr[0]}"
#  pwdLen="${rulesArr[1]}"

  # transform password so certain limitations are met
  for var in "${argz[@]}"
  do
    if [[ "$var" =~ ^[0-9]{2}$ ]]; then
      echo "truncate to len"
      trunc $var
      #echo $hash
    fi

    if [[ "$var" = "ucf" ]]; then
      echo "upper-char first"
      ucf
      #echo $hash
    fi

    if [[ "$var" = "spch" ]]; then
      echo "transform char"
      spch
      #echo $hash
    fi
  done

else
  echo "fetch rules from arguments"
  # transform password so certain limitations are met
  for var in "$@"
  do
    echo "eval [$var]"
    if [[ "$var" =~ ^[0-9]{2}$ ]]; then
#      echo "truncate to len"
      trunc $var
      #echo $hash
    fi

    if [[ "$var" = "ucf" ]]; then
#      echo "upper-char first"
      ucf
      #echo $hash
    fi

    if [[ "$var" = "spch" ]]; then
#      echo "transform char"
      spch
      #echo $hash
    fi
  done
fi


echo -n "$hash" | pbcopy
