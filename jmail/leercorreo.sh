#!/bin/bash

INBOX="/jmail/$USER"
LEIDOS="/jmail/$USER/leidos"

if [[ ! -d $INBOX ]]
then
	echo "NO EXISTES EN EL SISTEMA! ERES UN DON NADIE!"
	echo "(O tu carpeta no existe, por que no has recibido ningun correo)"
	exit 1
fi

if [[ ! -d $LEIDOS ]]
then
	echo "SE HA CREADO TU PU*ETERA CARPETA DE EMAILS LEIDOS"
	mkdir $LEIDOS
fi


NumeroDeMails=$(find "$INBOX" -maxdepth 1 -name "*.json" | wc -l)


if [[ $NumeroDeMails == 0 ]];
then
    echo "0 MENSAJES ¿ES QUE NADIE TE QUIERE?"
    exit 0
fi


echo "-------------------------------------------------------------"
echo "TE HAN LLAMADO $NumeroDeMails VECES, COJE EL PUTO TELEFONO"
echo "-------------------------------------------------------------"
read -p "PRESIONA ENTER PARA LEER"



for mail in "$INBOX"/*.json
do


	clear
	echo "========== MENSAJE: $(basename "$mail") =========="

	# Esto es feo, pero la alternativa es usar JQ, y ** NO ** me gusta usar programas externos (Creo que tengo altruismo o TDAH o algo por el estilo)
	DE=$(grep '"DE":' "$mail" | cut -d '"' -f 4)
	ASUNTO=$(grep '"ASUNTO":' "$mail" | cut -d '"' -f 4)
	CUERPO=$(grep '"CUERPO":' "$mail" | cut -d '"' -f 4)

	echo "DE:      $DE"
	echo "ASUNTO:  $ASUNTO"
	echo "--------------------------------------------------"
	echo "MENSAJE:"
	echo "$CUERPO"
	echo "--------------------------------------------------"

	read -p "[ENTER] PARA LA SIGUIENTE RONDA, [C] PARA ENCARGARME DE EL (Borrarlo), [Q] PARA HUIR COMO UNA NENAZA (Salir) > " OPCION

	case $OPCION in
		[Cc]* )
			rm -rvf "$mail" # F por que si no nos "pide" si queremos borar el archivo protegido
		;;
		[Qq]* )
			echo "PUEDES CORRER PERO NO ESCONDERTE"
			exit 0
		;;
		* )
			mv "$mail" "$LEIDOS/"
			echo "GUARDADA UNA COPIA EN LEIDOS/"
		;;
	esac
	sleep 1
done

echo "ESTAS AL DIA JODER."
