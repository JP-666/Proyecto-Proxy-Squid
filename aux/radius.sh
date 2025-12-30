#!/bin/bash

# Instala y configura RADIUS

if [[ $UID != 0 ]]
then
	echo "Vuelve como root"
	exit
fi

apt install freeradius freeradius-mysql mariadb-common mariadb-server -y

cp -rvf cosas/radius-sitio-default /etc/freeradius/3.0/sites-enabled/default
cp -rvf cosas/radius-eap /etc/freeradius/3.0/mods-enabled/eap
cp -rvf cosas/sqlconfradius /etc/freeradius/3.0/mods-enabled/sql

mysql -e "CREATE DATABASE baseradius;"
mysql -e "CREATE USER 'Fran' IDENTIFIED BY 'FranPassword';"
mysql -e "GRANT ALL ON baseradius.* TO 'Fran';"
mysql -e "FLUSH PRIVILEGES;"
mysql -D baseradius < /etc/freeradius/3.0/mods-config/sql/main/mysql/schema.sql

for i in {1..5}; # 5 profesores
do
	PROF=prof$i
	CONT=$RANDOM$RANDOM$RANDOM
	echo "Agregando usuario $PROF con contraseña $CONT"
	mysql -u Fran -pFranPassword -D baseradius -e "INSERT INTO radcheck (username, attribute, op, value) VALUES ('$PROF', 'Cleartext-Password', ':=', '$CONT');"
done
i=0 # Reseteamos $i

for i in {1..50}; # 50 alumnos
do
	ALM=alum$i
	CONT=$RANDOM$RANDOM$RANDOM
	echo "Agregando usuario $ALM con contraseña $CONT"
	mysql -u Fran -pFranPassword -D baseradius -e "INSERT INTO radcheck (username, attribute, op, value) VALUES ('$ALM', 'Cleartext-Password', ':=', '$CONT');"
done
exit

echo "Permitiendo copias de seguridad ahora..."

echo "[mysqld]" > /etc/mysql/mariadb.conf.d/99-permitir-copias.cnf
echo "bind-address            = 0.0.0.0" >> /etc/mysql/mariadb.conf.d/99-permitir-copias.cnf

systemctl restart freeradius mariadb
