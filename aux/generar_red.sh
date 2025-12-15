#!/bin/bash
# Genera una config de red.
# args: red? (1-4), ip, adp, dir, nms

if [[ $1 == 1 ]]
then
	echo "Estas personalizando la primera red, se genera un nuevo archivo... CANCELA EN 3 SEGUNDOS PARA ABORTAR"
	sleep 3
	echo "auto lo" > cosas/interfaces.custom
	echo "iface lo inet loopback" >> cosas/interfaces.custom
	echo "" >> cosas/interfaces.custom
	echo "auto enp0s3" >> cosas/interfaces.custom
	echo "iface enp0s3 inet dhcp" >> cosas/interfaces.custom
fi


while true; do
	echo ""
	echo ""
	echo "A continuacion se pediran varios datos sobre la red, si te equivocas, no uses ctrl-c, di que no en el mensaje de confimacion"
	read -p "IP para la red $1: ($2) > " ip
	read -p "Adaptador red $1: ($3) > " adp
	read -p "Direccion red $1: ($4) > " dir
	read -p "Netmask red $1: ($5) > " nms

	if [[ -z $ip ]]
	then
		ip=$2
	fi
	if [[ -z $adp ]]
	then
		adp=$3
	fi
	if [[ -z $dir ]]
	then
		dir=$4
	fi
	if [[ -z $nms ]]
	then
		nms=$5
	fi

	echo "IP: $ip"
	echo "Adaptador: $adp"
	echo "Red: $dir"
	echo "Mascara de red: $nms"

	read -p "¿Es correcta la informacion? [S/N]> ? " opb
	case $opb in
		[Ss]* )
			echo "¡Procediendo a generar!"
			echo
			echo "auto $adp" >> cosas/interfaces.custom
			echo "iface $adp inet static" >> cosas/interfaces.custom
			echo "	address $ip" >> cosas/interfaces.custom
			echo "	netmask $nms" >> cosas/interfaces.custom
			echo "	network $dir" >> cosas/interfaces.custom
			echo ""
			export red$1=$dir
			export router$1=$ip
			break;;
		[Nn]* )
			echo "Intenta de nuevo";;
	esac
done
echo ""
echo ""	
