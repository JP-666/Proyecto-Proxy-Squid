#!/bin/bash
echo
echo "Se va a proceder a comprobar unos requisitos... Por favor, espera"
echo
echo "[+] Test Superusuario"

Pruebas=(cosas/interfaces cosas/acl cosas/squid.conf cosas/sitio cosas/base_router.sql cosas/isc-default cosas/dhcp cosas/radius-eap cosas/radius-sitio-default cosas/sqlconfradius)
nb=(netboot.sh netboot/post.sh netboot/menu netboot/conf_tftp aux/gen_pre.sh iventoy.sh)
jm=(adjunto.php alertas.sh borrar.php enviarcorreo.php enviarcorreo.sh jmail.conf jmail.php leercorreo.php leerweb.sh README.md sjmail.service vercorreosusuario.php alertas.service bashrc descargar.php enviarcorreoseguro.py jmail_comun.py jmail.json jmail.service leercorreo.sh Makefile server.py sserver.py)
srv=(cambiar.php comun.php contra.php index.php reiniciar.php)

if [[ $UID != 0 ]]
then
	error="\nNo eres superusuario"
	echo "[!] Superusuario: No"
else
	echo "[+] Superusuario: Si"
fi

sleep 0.1 # Los sleeps para que el usuario vea lo que va pasando

echo "[+] Comprobando estructura de carpetas..."

if [[ ! $(basename $PWD) == "Proyecto-Proxy-Squid" ]]
then
	error="No estas en la carpeta base\n"
	echo "[!] Ubicacion: Mal"
else
	echo "[+] Pareces estar en la carpeta correcta"
fi

sleep 0.1

if [[ ! -f "extras/coco.jpeg" ]]
then
	echo "[!] Coco: No"
	error="\n$error Falta archivo integral 'extras/coco.jpeg'"
else
	echo "[+] coco.jpeg presente"
fi

echo
echo "[+] Comprobando archivos necesarios"
echo
for i in "${Pruebas[@]}"
do
	if [[ -f "$i" ]]
	then
		echo "[+] Existe: $i"
	else
		echo "[!] No existe: $i"
		error="$error \nError en $i (No existe o no es ejecutable)"
	fi
sleep 0.1
done


echo
echo "[+] Comprobando archivos jmail"
echo

for i in "${jm[@]}"
do
	if [[ -f "jmail/$i" ]]
	then
		echo "[+] Existe: $i"
	else
		echo "[!] No existe: $i"
		error="$error \nError en $i (No existe o no es ejecutable)"
	fi
sleep 0.1
done

echo
echo "[+] Comprobando archivos interfaz"
echo

for i in "${srv[@]}"
do
	if [[ -f "srv/$i" ]]
	then
		echo "[+] Existe: $i"
	else
		echo "[!] No existe: $i"
		error="$error \nError en $i (No existe o no es ejecutable)"
	fi
sleep 0.1
done

echo
echo "[+] Comprobando archivos para netboot"
echo


for i in "${nb[@]}"
do
	if [[ -f "$i" ]]
	then
		echo "[+] Existe: $i"
	else
		echo "[!] No existe: $i - Pero esto no es necesario"
	fi
sleep 0.1
done





if [[ ! -z $error ]] # ¿Por que he usado ! si iba a poner un else de todas formas?
then
	echo
	echo "Se han encontrado errores:"
	echo -e $error
	echo
	exit
else
	read -p "Todas las comprobaciones OK. Presiona enter. "
fi

echo "[1] Instalacion"
echo "Hackeandote el sistema... Espera unos minutos (Esto va a tardar un poco)"
echo
echo "(Si esto tarda, usa el comando 'tail --follow $(dirname $0)/log')"
apt update >> log
DEBIAN_FRONTEND=noninteractive apt install -y -qq whois iptables squid-openssl iptables-persistent isc-dhcp-server nginx php-fpm openssh-server git freeradius freeradius-mysql mariadb-common mariadb-server php-mysql mysql-common mariadb-client mariadb-server sudo jq >> log
echo "[2] IPTABLES"

iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
echo "[+] iptables - 1"
sleep 0.1

iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 80 -j REDIRECT --to-port 3128
echo "[+] iptables - 2"
sleep 0.1

iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 443 -j REDIRECT --to-port 3129
echo "[+] iptables - 3"
sleep 0.1

iptables -t nat -A PREROUTING -i enp0s9 -p tcp --dport 80 -j REDIRECT --to-port 3128
echo "[+] iptables - 4"
sleep 0.1

iptables -t nat -A PREROUTING -i enp0s9 -p tcp --dport 443 -j REDIRECT --to-port 3129
echo "[+] iptables - 5"
sleep 0.1

iptables -t nat -A PREROUTING -i enp0s10 -p tcp --dport 80 -j REDIRECT --to-port 3128
echo "[+] iptables - 6"
sleep 0.1

iptables -t nat -A PREROUTING -i enp0s10 -p tcp --dport 443 -j REDIRECT --to-port 3129
echo "[+] iptables - 7"
sleep 0.1

netfilter-persistent save
echo "[+] iptables - Guardado"
sleep 0.1

echo "[3] SSH - Root"
echo "Permitiendo loguearse como Root con contraseña por SSH"
cat /usr/share/openssh/sshd_config | sed 's/\#PermitRootLogin prohibit-password/PermitRootLogin yes/g' > /etc/ssh/sshd_config
echo "[+] SSH - Permitido"
sleep 0.1
echo "Reiniciando SSH..."
systemctl restart sshd
echo "[+] SSH - Reiniciado"
sleep 0.1


echo "[4] Forwarding"
echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf
echo "[+] Forwarding - Hecho"
sleep 0.1
sysctl -p
echo "[+] Forwarding - Hecho"
sleep 0.1

echo "[5] Copiando archivos de /srv/"
cp -r srv / >&2
echo "[+] Copia - srv"
sleep 0.1

echo "Saltando [6]..."
echo "[+] [6] - Saltado"
sleep 0.1

echo "[7] Conf. Red"
cp cosas/interfaces /etc/network/interfaces
echo "[+] Copia - interfaces"
sleep 0.1


echo " - Reiniciando red"
systemctl restart networking
echo "[+] Reinicio - networking"
sleep 0.1

echo "[8] Copiando squid"
cp cosas/acl /etc/squid/acl.txt
echo "[+] Copia - acl"
sleep 0.1

cp cosas/squid.conf /etc/squid/squid.conf
echo "[+] Copia - squid.conf"
sleep 0.1

echo "[9] Creando certificados"
mkdir -p /etc/squid/ssl_cert
echo "[+] Carpeta ssl - creada"
sleep 0.1

chmod 700 /etc/squid/ssl_cert
echo "[+] Carpeta SSL - permisos"
sleep 0.1

openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -keyout /etc/squid/ssl_cert/squid_ca.key -out /etc/squid/ssl_cert/squid_ca.pem -sha256 -subj "/C=ES/ST=Andalucia/L=Andalucia/O=Instituto/OU=SquidInstituto/CN=SSL para proxy squid"
echo "[+] SSL - Generado"
sleep 0.1

chown proxy:proxy /etc/squid/ssl_cert
echo "[+] Carpeta SSL - permisos (2)"
sleep 0.1

mkdir -p /var/lib/squid/
echo "[+] Carpeta var lib squid - creada"
sleep 0.1

/usr/lib/squid/security_file_certgen -c -s /var/lib/squid/ssl_db -M 4MB
echo "[+] Generando cache certificados"
sleep 0.1

chown -R proxy:proxy /var/lib/squid/ssl_db
echo "[+] Cache certificados - permisos"
sleep 0.1


echo " - Reiniciando squid (Esto va a tardar un poco...)"
systemctl restart squid
echo "[+] Reinicio - squid"
sleep 0.1

echo "[10] Conf. dhcp"
cp cosas/dhcp /etc/dhcp/dhcpd.conf
echo "[+] Copia - dhcp"
sleep 0.1

cp cosas/isc-default /etc/default/isc-dhcp-server
echo "[+] Copia - dhcp (2)"
sleep 0.1

systemctl restart isc-dhcp-server
echo "[+] Reinicio - dhcp"
sleep 0.1



echo "[11] Conf. Nginx"
rm /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default
echo "[+] NGINX - Borrando sitio por defecto"
sleep 0.1

cp cosas/sitio /etc/nginx/sites-enabled/default
echo "[+] NGINX - Creando sitio por defecto"
sleep 0.1

cp cosas/sitio /etc/nginx/sites-available/default # Esto no hace falta
echo "[+] NGINX - Creando sitio por defecto (2)"
sleep 0.1

php_dir=$(ls -d /etc/php/[0-9].* 2>/dev/null | tail -n 1)
echo "[+] PHP: $php_dir"
sleep 0.1

versionphp=$(basename "$php_dir")
echo "[+] PHP Recortado - $versionphp"
sleep 0.1

cp /etc/squid/ssl_cert/squid_ca.pem /srv/certi.pem
echo "[+] NGINX - Copiado certificado para descarga"
sleep 0.1

mysql < cosas/base_router.sql
echo "[+] SQL - Base router"
sleep 0.1


echo -n "Introduce la nueva contraseña. NO SALDRA EN EL TERMINAL > "
read -s ncont
conthash=$(php -r "echo password_hash('$ncont', PASSWORD_BCRYPT);")
mysql -D router -e "UPDATE datoslogin SET contrahash = \"$conthash\" WHERE usuario = \"admin\";"
echo "[+]  SQL - Cambio contraseña"
sleep 0.1

echo "www-data ALL=(ALL) NOPASSWD: /sbin/reboot" >> /etc/sudoers
echo "[+] NGINX - Reglas de sudo "
sleep 0.1

systemctl restart nginx php$versionphp-fpm
echo "[+] Reiniciando - NGINX y PHP"
sleep 0.1


echo "[12] Haciendo RADIUS"
cp -rvf cosas/radius-sitio-default /etc/freeradius/3.0/sites-enabled/default
echo "[+] Copia - Radius (1/3)"
sleep 0.1

cp -rvf cosas/radius-eap /etc/freeradius/3.0/mods-enabled/eap
echo "[+] Copia - Radius (2/3)"
sleep 0.1

cp -rvf cosas/sqlconfradius /etc/freeradius/3.0/mods-enabled/sql
echo "[+] Copia - Radius (3/3)"
sleep 0.1

mysql -e "CREATE DATABASE baseradius;"
echo "[+] SQL - baseradius"
sleep 0.1

mysql -e "CREATE USER 'Fran' IDENTIFIED BY 'FranPassword';"
echo "[+] SQL - Crear usuario"
sleep 0.1

mysql -e "GRANT ALL ON baseradius.* TO 'Fran';"
echo "[+] SQL - Permisos"
sleep 0.1

mysql -e "FLUSH PRIVILEGES;"
echo "[+] SQL - Privilegios"
sleep 0.1

mysql -D baseradius < /etc/freeradius/3.0/mods-config/sql/main/mysql/schema.sql
echo "[+] SQL - Radius / Estructura"
sleep 0.1


for i in {1..5};
do
	PROF=prof$i
	CONT=$RANDOM$RANDOM$RANDOM
	CHASH=$(mkpasswd $CONT)
	echo "[+] RADIUS - Agregando usuario $PROF con contraseña $CONT ($i/5)"
	mysql -u Fran -pFranPassword -D baseradius -e "INSERT INTO radcheck (username, attribute, op, value) VALUES ('$PROF', 'Crypt-Password', ':=', '$CHASH');"
	sleep 0.1
done
i=0
for i in {1..50};
do
	ALM=alum$i
	CONT=$RANDOM$RANDOM$RANDOM
	CHASH=$(mkpasswd $CONT)
	echo "[+] RADIUS - Agregando usuario $ALM con contraseña $CONT ($i/50)"
	mysql -u Fran -pFranPassword -D baseradius -e "INSERT INTO radcheck (username, attribute, op, value) VALUES ('$ALM', 'Crypt-Password', ':=', '$CHASH');"
	sleep 0.1
done
sleep 0.1


echo "Permitiendo copias de seguridad ahora..."
echo "[mysqld]" > /etc/mysql/mariadb.conf.d/99-permitir-copias.cnf
echo "bind-address            = 0.0.0.0" >> /etc/mysql/mariadb.conf.d/99-permitir-copias.cnf
echo "[+] SQL - Copias / Permitir IPs con contraseña"
sleep 0.1

systemctl restart freeradius mariadb
echo "[+] Reiniciar / FreeRADIUS y MariaDB"
sleep 0.1

cd jmail/
echo "[+] Entrado en carpeta jmail"
sleep 0.1

echo "[13] Instalando JMAIL"
echo "[+] Configuracion (jmail.conf)"
mkdir -p /etc/jmail
echo "[+] JMAIL - Crear directorio"
sleep 0.1

cp jmail.conf /etc/jmail/
echo "[+] JMAIL - Copiar archivo jmail.conf por defecto"
sleep 0.1

echo "[+] JMAIL - Usando make para instalar el servidor"
sleep 0.2
make instalar

echo "[+] Enviar correo (enviarcorreo)"
cp enviarcorreo.sh /usr/bin/enviarcorreo
chmod +x /usr/bin/enviarcorreo
echo "[+] JMAIL - enviarcorreo"
sleep 0.1

echo "[+] Enviar correo seguro (enviarcorreoseguro)"
cp enviarcorreoseguro.py /usr/bin/enviarcorreoseguro
chmod +x /usr/bin/enviarcorreoseguro
echo "[+] JMAIL - enviarcorreoseguro"
sleep 0.1

echo "[+] Leer correo (leercorreo)"
cp leercorreo.sh /usr/bin/leercorreo
chmod +x /usr/bin/leercorreo
echo "[+] JMAIL - leercorreo"
sleep 0.1

mkdir -p /etc/sudoers.d/
echo "www-data ALL=(ALL) NOPASSWD: /usr/bin/leerweb.sh" >> /etc/sudoers.d/jmail
chmod 440 /etc/sudoers.d/jmail -Rvf
echo "[+] JMAIL - Reglas de sudo"
sleep 0.1


echo "[+] JMAIL - PHP / inicio"
sleep 0.1
cp  leerweb.sh /usr/bin/
echo "[+] JMAIL - PHP / Script superusuario"
sleep 0.1

cp  enviarcorreo.php /srv/
echo "[+] JMAIL - PHP / enviarcorreo.php"
sleep 0.1

cp  descargar.php /srv/
echo "[+] JMAIL - PHP / descargar.php"
sleep 0.1

cp  leercorreo.php /srv/
echo "[+] JMAIL - PHP / leercorreo.php"
sleep 0.1

cp  vercorreosusuario.php /srv/
echo "[+] JMAIL - PHP / vercorreosusuario.php"
sleep 0.1

cp  jmail.php /srv/
echo "[+] JMAIL - PHP / jmail.php"
sleep 0.1

cp  adjunto.php /srv/
echo "[+] JMAIL - PHP / adjunto.php"
sleep 0.1

cat bashrc >> $HOME/.bashrc
echo "[+] JMAIL - Alertas BASH"
sleep 0.1


cp alertas.sh /usr/bin/alertas
chmod +x /usr/bin/alertas
cp alertas.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now alertas
echo "[+] JMAIL - Alertas SQUID por JMAIL"
sleep 0.1



cd -
echo "[+] Volviendo a carpeta anterior ($PWD)"
sleep 0.1


echo
echo "Asegurate de instalar tambien de ejecutar aux/backup.sh en al menos un cliente!"
echo
echo
echo "Los siguientes pasos:"
echo "	- Haz el netboot (netboot.sh / iventoy.sh)"
