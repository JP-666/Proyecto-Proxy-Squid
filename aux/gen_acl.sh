#!/bin/bash

if [[ -f cosas/acl ]]
then
	echo "Usando lista existente..."
else
	echo "Se generara una nueva ACL en el directorio cosas"
	echo > cosas/acl
fi

echo "Al final podras editar el archivo, no te preocupes por los errores"

while true
do
	read -p "Dominio (P.E: instagram.com) (salir -> Sale del programa) ? " dom
	if [[ ! -z $dom ]]
	if [[ $dom == "salir" ]]
	then
		break
	fi
	then
		echo "Añadiendo $dom a la lista"
		echo ".$dom" >> cosas/acl
	fi
done

nano cosas/acl

if [[ $UID != 0 ]]
then
	echo "No se puede copiar, no eres superusuario, se ha guardado el archivo"
else
	cp -rvf cosas/acl /etc/squid/acl.txt
fi
