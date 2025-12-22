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

echo "A continuacion se te soltara en nano, en el archivo, para que lo edites, esto es opcional, puedes simplemente salir..."
sleep 3

nano cosas/acl
