#!/usr/bin/env bash
#
# Serialize domain-specific hash transformations so they will be done automagically per domain

db="$HOME/pwh.db"
#echo "Using db: $db"

if [[ ! -f ${db} ]]; then
  echo "Database unavailable. Please install first"
  exit 1
fi

action=$1
shift
domain=$1
shift

# Return a bitmask for which rules to serialise
parseArgs(){
  ret=0

	if [[ "$@" =~ "ucf" ]]; then
	  ret=$(($ret + 1))
  fi

	if [[ "$@" =~ "spch" ]]; then
	  ret=$(($ret + 2))
  fi

	if [[ "$@" =~ [0-9]{2} ]]; then
	  ret=$(($ret + 4))
  fi

  echo $ret
}

# Add/modify rules
addDomainRules(){
  rules=$(parseArgs "$@")
  len="NULL"

#  echo "rules: $rules"
#
#  if (( $((rules & 1)) | 0 ))
#  then
#    echo "UCF recognised";
#  fi
#
#  if (( $((rules & 2)) | 0 ))
#  then
#    echo "SPCH recognised";
#  fi

  if (( $((rules & 4)) | 0 ))
  then
    for var in "$@"
    do
      if [[ "$var" =~ ^[0-9]{2}$ ]]; then
        len=$var
      fi
    done
  fi

#  echo "insert or ignore into domain_rules (domain, rules_mask, pwd_len) values('$domain', $rules, $len); update domain_rules set rules_mask = $rules, pwd_len = $len where domain = '$domain';"
  sqlite3 "$db" "insert or ignore into domain_rules (domain, rules_mask, pwd_len) values('$domain', $rules, $len); update domain_rules set rules_mask = $rules, pwd_len = $len where domain = '$domain';"
}

# Get rules
getDomainRules(){
  domain=$1

	rulesData=`sqlite3 "$db" "select rules_mask, pwd_len from domain_rules where domain = '$domain';"`

  IFS='|' read -ra rulesArr <<< "$rulesData"

  rules="${rulesArr[0]}"
  pwdLen="${rulesArr[1]}"

  str=""

  if (( $((rules & 1)) | 0 ))
  then
    str="ucf $str"
  fi

  if (( $((rules & 2)) | 0 ))
  then
#    echo "SPCH recognised";
    str="spch $str"
  fi

  if (( $((rules & 4)) | 0 ))
  then
    str="$pwdLen $str"
  fi
  echo $str
}

# Remove rules
dropDomainRules(){
  domain=$1

#	echo "drop rules for domain $domain in database $db"
	sqlite3 "$db" "delete from domain_rules where domain = '$domain';"
}

if [[ "$action" = "add" ]]; then
  addDomainRules $@
elif [[ "$action" = "get" ]]; then
  getDomainRules $domain
elif [[ "$action" = "drop" ]]; then
  dropDomainRules $domain
fi

