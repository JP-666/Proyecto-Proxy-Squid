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






msgaenviar="{
\"MAIL\": {
		\"PARA\": \"$DESTINO\",
		\"DE\": \"$QUIEN\",
		\"ASUNTO\": \"$ASUNTOSPENDIENTES\",
		\"CUERPO\": \"$MENUDOCUERPAZO\"
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

