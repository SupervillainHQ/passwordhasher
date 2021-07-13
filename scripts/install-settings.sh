#!/usr/bin/env bash
#
# Install local sqlite database so domain-specific hash transformations can be done automagically

db="$HOME/pwh.db"

if [[ ! -f ${db} ]]; then
  echo "Installing db: $db"
  sqlite3 "$db" ".tables;"
fi

if [[ ! -f ${db} ]]; then
  echo "database updating..."
  sqlite3 "$db" "create table domain_rules (id integer primary key, domain text unique not null, rules_mask integer, pwd_len integer);"
  echo "database updated"
fi

