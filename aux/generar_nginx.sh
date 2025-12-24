#!/bin/bash
#!/bin/laden


if [[ ! -z $router1 ]]
then
	read -p "La variable router1, la cual es requerida para generar la configuracion de NGINX no esta establecida, esto puede ser un problema mayor, deberias investigar esto, de todos modos, introduce la IP de escucha: " router1
fi
