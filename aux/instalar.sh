#!/bin/bash

if [[ $interfaz == "no" ]]
then
	apt install -y iptables squid-openssl iptables-persistent isc-dhcp-server openssh-server git
else
	apt install -y iptables squid-openssl iptables-persistent isc-dhcp-server nginx php-fpm openssh-server git
fi
