#!/bin/bash

# Este script deberia ejecutarse en el CLIENTE.

if [[ -v $(which mysqldump) ]]
then
	sudo apt install mariadb-common mariadb-client -y
fi
if [[ ! -d $HOME/backups ]]
then
	mkdir $HOME/backups
fi

read -p 'IP del servidor > ' ip

if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] # Esto es regex, que lo copiado de internet, pero se lo que hace.
then
	read -p "Base de datos > " base
	read -p "Usuario de la base de datos > " usuario
	read -p "Contraseña > " contra

	echo "mysqldump -h $ip -u $usuario -p$contra --skip-ssl $base > $HOME/backups/backup_\$(date).sql"
else
	echo "Introduce una ip valida!"
fi
