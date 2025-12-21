#!/bin/bash

read -p "Donde esta la DB (10.0.0.1) ? " otrohost
read -p "Usuario del sistema (root) ? " usuario

if [[ -z $otrohost ]]
then
	otrohost=10.0.0.1
fi

if [[ -z $usuario ]]
then
	usuario=root
fi


# Generamos la clave local
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519

# La copiamos
ssh-copy-id $usuario@$otrohost

# Creamos el cron

(crontab -l 2>/dev/null; echo "0 0 * * * ssh $usuario@otrohost -c 'mysqldump -d baseradius' > $HOME/RADIUS$RANDOM") | crontab -
