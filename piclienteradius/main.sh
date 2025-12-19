#!/bin/bash

# Instala HOSTAPD y crea un punto de acceso para probar RADIUS
# Auto-instalandose como servicio con systemd
# Esta ideado para un Raspberry Pi, pero deberia funcionar
# Con cualquier dispositivo Linux con WiFi+Ethernet

if [[ ! $(basename $PWD) == "piclienteradius" ]]
then
	echo "Estas en la carpeta 'piclienteradius'?"
	echo "basename $PWD != piclienteradius"
	echo "Script en $(dirname $(which $0))/"
	exit
fi


arc=$(uname --machine)
if [[ ! $arc == "arm64" ]]
then
	echo "Este script esta pensado para dispositivos con ARM64!"
	if [[ $arc == "x86_64" ]]
	then
		echo "Se puede continuar, x64"
	else
		echo "La arquitectura se desconoce, no voy a hacer lo que me digas."
		exit 1
	fi
fi

if [[ $UID != 0 ]]
then
	echo "Entra como root!"
	exit
fi

if [[ -f $(which hostapd) ]]
then
	PATH=$PATH:/sbin/ # Por que en Debian (<3) normalmente /sbin/ no se encuentra en el PATH si entramos como sudo/doas.
	echo "Hostapd se encuentra instalado en $(which hostapd), saltando la instalacion"
	
else
	echo "A continuancion se instala hostapd. Por favor mantente a la espera"
	apt update
	apt install hostapd
	source aux/generar_hostapd.sh
	# Logica que pregunta si hacerlo permanente
	# Entonces...
		# Logica que añade el servicio a SystemD
	# Si no...
		# Crea una red con HostAPD
fi


