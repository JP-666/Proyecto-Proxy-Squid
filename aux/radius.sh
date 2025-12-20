#!/bin/bash

# Instala y configura RADIUS

if [[ $UID != 0 ]]
then
	echo "Vuelve como root"
	exit
fi

apt install freeradius freeradius-mysql -y

cp -rvf cosas/radius-sitio-default /etc/freeradius/3.0/sites-enabled/default
cp -rvf cosas/radius-eap /etc/freeradius/3.0/mods-enabled/eap
cp -rvf cosas/sqlconfradius /etc/freeradius/3.0/mods-enabled/sql
