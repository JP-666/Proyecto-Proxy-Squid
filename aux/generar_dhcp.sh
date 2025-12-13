#!/bin/bash

if [[ ! -f cosas/dhcp.custom ]]
then
	echo "Generando un nuevo archivo dhcp.custom"
fi
if [[ ! $4 == "--append" ]]
then

	echo "ddns-update-style none;
	default-lease-time 600;
	max-lease-time 7200;
	authoritative;
	option domain-name-servers 8.8.8.8, 8.8.4.4;
	option domain-name \"redinsti\";" > cosas/dhcp.custom
fi

BASE_IP="${2%.*}"
echo "Creando config para $2, con ip de router $1 y con netmask $3" 
echo "subnet $2 netmask $3 {
    range $BASE_IP.100 $BASE_IP.250;
    option routers $1;
    option broadcast-address $BASE_IP.255;
}" >> cosas/dhcp.custom
