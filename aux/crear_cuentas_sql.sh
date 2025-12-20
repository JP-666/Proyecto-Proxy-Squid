#!/bin/bash

USUARIO="CAMBIA ESTO"
CONTRA="ESTO TAMBIEN"
BASE="Y ESTO, CLARO"

if [[ $USUARIO == "CAMBIA ESTO" ]]
then
	echo "No has puesto bien los ajustes de la base de datos!"
	echo "Edita el archivo (nano $0) para arreglar este error!"
	exit
fi


# Popula la base datos de RADIUS con cuentas aleatorias

if [[ $1 == "--popular" ]]
then
	for i in {1..5}; # 5 profesores
	do
		PROF=prof$i
		CONT=$RANDOM$RANDOM$RANDOM
		echo "Agregando usuario $PROF con contraseña $CONT"
		mysql -u $USUARIO -p$CONTRA -D $BASE -e "INSERT INTO radcheck (username, attribute, op, value) VALUES ('$PROF', 'Cleartext-Password', ':=', '$CONT');"
	done
	i=0 # Reseteamos $i

	for i in {1..50}; # 50 alumnos
	do
		ALM=alum$i
		CONT=$RANDOM$RANDOM$RANDOM
		echo "Agregando usuario $ALM con contraseña $CONT"
		mysql -u $USUARIO -p$CONTRA -D $BASE  -e "INSERT INTO radcheck (username, attribute, op, value) VALUES ('$ALM', 'Cleartext-Password', ':=', '$CONT');"
	done
	exit
fi

while true
do
	read -p "Nuevo usuario? (O \"salir\") > " Us
	if [[ $Us == "salir" ]]
	then
		echo "Saliendo..."
		break
	fi
	read -p "Contraseña? (O \"salir\") > " Cn
	if [[ $Cn == "salir" ]]
	then
		echo "Saliendo..."
		break
	fi

	echo "Agregando usuario $Us con contraseña $Cn"
	mysql -u $USUARIO -p$CONTRA -D $BASE  -e "INSERT INTO radcheck (username, attribute, op, value) VALUES ('$Us', 'Cleartext-Password', ':=', '$Cn');"
done

