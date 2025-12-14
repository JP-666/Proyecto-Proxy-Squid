#!/bin/bash
apt update
if [[ $interfaz == "no" ]]
then
	echo "Instalando sin nginx ni php"
	echo
	echo
	echo
	echo
	apt install -y iptables squid-openssl iptables-persistent isc-dhcp-server openssh-server git
else
	echo "Instalando todo"
	echo
	echo
	echo
	echo
	apt install -y iptables squid-openssl iptables-persistent isc-dhcp-server nginx php-fpm openssh-server git
fi
