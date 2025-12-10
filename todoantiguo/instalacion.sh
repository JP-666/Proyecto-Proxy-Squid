#!/bin/bash
# Este script instala squid-proxy

if [[ $UID != 0 ]]
then
  echo "Entra como superusuario!"
  exit
else
  apt update
  apt install squid
  echo "acl all src 0.0.0.0/0" >> "/etc/squid/squid.conf"
  echo "http_access allow all" >> "/etc/squid/squid.conf"
fi
