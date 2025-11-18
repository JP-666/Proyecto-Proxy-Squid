#!/bin/bash
# Este script instala squid-proxy

if [[ $UID != 0 ]]
then
  echo "Entra como superusuario!"
  exit
else
  apt update
  apt install squid
fi
