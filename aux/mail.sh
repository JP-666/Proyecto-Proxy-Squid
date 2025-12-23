#!/bin/bash

if [[ $UID != 0 ]]
then
	echo "Vuelve como root!"
	exit
fi


if [[ -z $router1 ]]
then
	echo "Usando red ya configurada... - $router1"
	ip=$router1
else
	read -p "IP de la interfaz (?) > " ip
fi

echo
echo
echo


BASE_IP="${ip%.*}"


cat > cosas/main.cf << EOF
myhostname = $ip
mydestination = \$myhostname, localhost
mynetworks = 127.0.0.0/8, $BASE_IP.0/24
inet_interfaces = all
inet_protocols = ipv4
EOF

echo
echo
echo

read -p "Ahora se instalara postfix, en la seleccion, marca la opcion \"sitio de internet\" - Presiona enter para continuar"

apt install postfix mailutils

cp -rvf cosas/main.cf /etc/postfix/main.cf
systemctl restart postfix
