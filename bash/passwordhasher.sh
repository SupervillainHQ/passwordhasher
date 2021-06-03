#!/usr/bin/env bash
#my string
#

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
			char=`echo $char | tr 0123456789 Ω!§∑ƒ@£†≈◊`
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

#echo "Domain: $domain"
#echo "Salt: $salt"

hash=`echo -n "$domain$salt" | md5`

# transform password so certain limitations are met
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

echo $hash

echo -n "$hash" | pbcopy
