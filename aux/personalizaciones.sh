#!/bin/bash

echo ""
read -p "¿Quieres personalizar la red 1 (Profesores) [S/N]> ? " opc

case $opc in
	N | n)
		echo "auto lo" > cosas/interfaces.custom
		echo "iface lo inet loopback" >> cosas/interfaces.custom
		echo "" >> cosas/interfaces.custom
		echo "auto enp0s8" >> cosas/interfaces.custom
		echo "iface enp0s8 inet static" >> cosas/interfaces.custom
		echo "	address 10.0.0.1" >> cosas/interfaces.custom
		echo "	netmask 255.255.255.0" >> cosas/interfaces.custom
		echo "	network 10.0.0.0" >> cosas/interfaces.custom
	;;
	*)
		source aux/generar_red.sh 1 10.0.0.1 enp0s8 10.0.0.0 255.255.255.0
		aux/generar_dhcp.sh $ip $dir $nms
	;;
esac

echo ""
read -p "¿Quieres personalizar la red 2 (Alumnos 1) [S/N]> ? " opc2

case $opc in
	N | n)
		echo "auto enp0s9" >> cosas/interfaces.custom
		echo "iface enp0s9 inet static" >> cosas/interfaces.custom
		echo "	address 172.16.1.1" >> cosas/interfaces.custom
		echo "	netmask 255.255.255.0" >> cosas/interfaces.custom
		echo "	network 172.16.1.0" >> cosas/interfaces.custom
	;;
	*)
		source aux/generar_red.sh 2 172.16.1.1 enp0s10 172.16.1.0 255.255.255.0
		aux/generar_dhcp.sh $ip $dir $nms --append
	;;
esac

echo ""
read -p "¿Quieres personalizar la red 3 (Alumnos 2) [S/N]> ? " opc3

case $opc in
	N | n)
		echo "auto enp0s10" >> cosas/interfaces.custom
		echo "iface enp0s10 inet static" >> cosas/interfaces.custom
		echo "	address 172.16.2.1" >> cosas/interfaces.custom
		echo "	netmask 255.255.255.0" >> cosas/interfaces.custom
		echo "	network 172.16.2.0" >> cosas/interfaces.custom
	;;
	*)
		source aux/generar_red.sh 3 172.16.2.1 enp0s10 172.16.2.0 255.255.255.0
		aux/generar_dhcp.sh $ip $dir $nms --append
	;;
esac


# Queda:
#	- Exportar variables (Por si las moscas) al script principal, o al terminal, si no estamos en un subscript.
#	- Conf. de NGINX (Cambiar los "routers" de alumnos y de profesores con las IPs de 1. 


echo ""
