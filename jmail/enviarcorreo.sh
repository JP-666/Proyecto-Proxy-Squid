#!/bin/bash


CUAL=42069

read -p '¿HOST? (localhost) > ' DONDE
if [[ -z $DONDE ]]
then
	echo "HAZ LAS COSAS BIEN JODER"
	DONDE=localhost
fi

read -p '¿PARA QUIEN? (root) > ' DESTINO
if [[ -z $DESTINO ]]
then
	echo "HAZ LAS COSAS BIEN JODER"
	DESTINO=root
fi


read -p '¿EL ASUNTO? (MI JMAIL) > ' ASUNTOSPENDIENTES
if [[ -z $ASUNTOSPENDIENTES ]]
then
	echo "HAZ LAS COSAS BIEN JODER"
	ASUNTOSPENDIENTES="MI JMAIL"
fi

read -p "¿QUIEN LLAMA? ($USER) > " QUIEN
if [[ -z $QUIEN ]]
then
	echo "HAZ LAS COSAS BIEN JODER"
	QUIEN=$USER
fi

read -p '¿CUERPO? (Feliz navidad, hijo de perra) > ' MENUDOCUERPAZO
if [[ -z $MENUDOCUERPAZO ]]
then
	echo "HAZ LAS COSAS BIEN JODER"
	MENUDOCUERPAZO="Feliz navidad, hijo de perra"
fi

while true
do

	read -p 'Quieres enviar algun campo mas ([Nombre del campo]/([Deja vacio])) ' campo
	if [[ ! -z $campo ]]
	then
		OPC="$OPC,
		\"$campo\" : "
		read -p "Valor para $campo (?) " valor
		OPC="$OPC\"$valor\""
	else
		break
	fi
done

read -p '¿Quieres adjuntar un archivo? (Ruta / [Enter para saltar]) ' f_adjunto
if [[ -f "$f_adjunto" ]]
then
	NOM_ADJUNTO=$(basename "$f_adjunto")
	CONT_ADJUNTO=$(base64 -w 0 "$f_adjunto")
	OPC="$OPC, \"ADJUNTO_NOMBRE\": \"$NOM_ADJUNTO\", \"ADJUNTO_DATA\": \"$CONT_ADJUNTO\""
fi


msgaenviar="{
\"MAIL\": {
		\"PARA\": \"$DESTINO\",
		\"DE\": \"$QUIEN\",
		\"ASUNTO\": \"$ASUNTOSPENDIENTES\",
		\"CUERPO\": \"$MENUDOCUERPAZO\"
$OPC
	}
}
HASTALAVISTABABY"



echo $msgaenviar | nc -w 5 $DONDE $CUAL

if [[ $? != 0 ]] # Mira, que vien que me viene SOR
then
	echo $msgaenviar > $HOME/$DATE.json
	echo "JODER, ESTAMOS SIENDO ATACADOS POR NOR-COREANOS"
	echo "(Ha habido un error en el envio)"
	echo "(Se ha guardado una copia del correo)"
fi

