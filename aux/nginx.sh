#!/bin/bash

echo "[11] Conf. Nginx"
apt install php-mysql
rm -rvf /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default
cp -rvf $archsitio /etc/nginx/sites-enabled/default
cp -rvf $archsitio /etc/nginx/sites-available/default
php_dir=$(ls -d /etc/php/[0-9].* 2>/dev/null | tail -n 1)
if [ -z "$php_dir" ]
then
	versionphp="No se ha encontrado PHP!"
else
	versionphp=$(basename "$php_dir")
fi
cp -rvf /etc/squid/ssl_cert/squid_ca.pem /srv/certi.pem
ln -sf /srv/certi.pem /srv/alumnos/certi.pem
mysql < cosas/base_router.sql
read -p "Quieres cambiar la contraseña del router? ((S)/N) > " crout
case $crout in
	N | n )
		echo "Ok, pero deberias, es importante"
	;;
	* )
		echo -n "Introduce la nueva contraseña. NO SALDRA EN LA TERMINAL > "
		read -s ncont
		conthash=$(php -r "echo password_hash('$ncont', PASSWORD_BCRYPT);")
		mysql -D router -e "UPDATE datoslogin SET contrahash = \"$conthash\" WHERE usuario = \"admin\";"
	;;
esac
echo "www-data ALL=(ALL) NOPASSWD: /sbin/reboot" >> /etc/sudoers
systemctl restart nginx php$versionphp-fpm
