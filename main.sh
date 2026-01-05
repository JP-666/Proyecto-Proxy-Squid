#!/bin/bash
echo
echo "Se va a proceder a comprobar unos requisitos... Por favor, espera"
echo
echo "[+] Test Superusuario"

Pruebas=(cosas/interfaces cosas/acl cosas/squid.conf cosas/sitio cosas/base_router.sql cosas/isc-default cosas/dhcp cosas/radius-eap cosas/radius-sitio-default cosas/sqlconfradius)

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


echo "[+] Comprobando archivos necesarios"
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


if [[ ! -z $error ]]
then
	echo
	echo "Se han encontrado errores:"
	echo -e $error
	echo
	exit
fi

echo
echo
echo
echo "##############################################"
echo "###               Mega-Script              ###"
echo "###               Instalacion              ###"
echo "##############################################"
echo
echo "A continuacion se seguiran una serie de pasos:"
echo "  1. Personalizar la instalacion"
echo "  2. Generar configuraciones externas (SQUID, NGINX)"
echo "  3. Instalar los paquetes necesarios"
echo "  4. Configurar IPTABLES"
echo "  5. Permitir loguearse como root con contraseña a traves de SSH (OPCIONAL)"
echo "  6. Configurar el sistema (sysctl)"
echo "  7. Instalar la interfaz (OPCIONAL)"
echo "  8. Configurar la red"
echo "  9. Configurar SQUID (Y sus ACL (OPCIONALES))"
echo "  10. Configurar el servidor DHCP"
echo "  11. Configurar RADIUS"
echo
echo


echo "[1] Instalacion"
DEBIAN_FRONTEND=noninteractive apt install -y -qq iptables squid-openssl iptables-persistent isc-dhcp-server nginx php-fpm openssh-server git freeradius freeradius-mysql mariadb-common mariadb-server php-mysql mysql-common mariadb-client mariadb-server
echo "[2] IPTABLES"

iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 80 -j REDIRECT --to-port 3128
iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 443 -j REDIRECT --to-port 3129
iptables -t nat -A PREROUTING -i enp0s9 -p tcp --dport 80 -j REDIRECT --to-port 3128
iptables -t nat -A PREROUTING -i enp0s9 -p tcp --dport 443 -j REDIRECT --to-port 3129
iptables -t nat -A PREROUTING -i enp0s10 -p tcp --dport 80 -j REDIRECT --to-port 3128
iptables -t nat -A PREROUTING -i enp0s10 -p tcp --dport 443 -j REDIRECT --to-port 3129
netfilter-persistent save

echo "[3] SSH - Root"
echo "Permitiendo loguearse como Root con contraseña por SSH"
cat /usr/share/openssh/sshd_config | sed 's/\#PermitRootLogin prohibit-password/PermitRootLogin yes/g' > /etc/ssh/sshd_config
echo "Reiniciando SSH..."
systemctl restart sshd
echo "[4] Forwarding"
echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf
sysctl -p
echo "[5] Copiando archivos de /srv/"
cp -rvf srv / >&2
echo "Saltando [6]..."
echo "[7] Conf. Red"
cp cosas/interfaces /etc/network/interfaces -rvf
echo " - Reiniciando red"
systemctl restart networking
echo "[8] Copiando squid"
cp -rvf cosas/acl /etc/squid/acl.txt
cp cosas/squid.conf /etc/squid/squid.conf -rvf
echo "[9] Creando certificados"
echo

read -p "Pais ? (Corto, p.e: ES) ? > " pais
read -p "Region ? (p.e: Andalucia) ? > " reg
read -p "Institucion ? (p.e: Instituto) ? > " ins
read -p "Organizacion ? (p.e: InstitutoXYZ) ? > " org
read -p "CA ? (p.e: Mi certificado para lo que sea) ? > " extra

if [[ -z $pais ]]
then
	pais=ES
fi
if [[ -z $reg ]]
then
	reg=Andalucia
fi
if [[ -z $ins ]]
then
	ins=instituto
fi
if [[ -z $org ]]
then
	org=squidinstituto
fi
if [[ -z $extra ]]
then
	extra="CERTIFICADO PARA SSL DE SQUID DEL INSTITUTO"
fi

mkdir -p /etc/squid/ssl_cert
chmod 700 /etc/squid/ssl_cert
openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -keyout /etc/squid/ssl_cert/squid_ca.key -out /etc/squid/ssl_cert/squid_ca.pem -sha256 -subj "/C=$pais/ST=$reg/L=$reg/O=$ins/OU=$org/CN=$extra"
chown proxy:proxy /etc/squid/ssl_cert -Rvf
mkdir -p /var/lib/squid/
/usr/lib/squid/security_file_certgen -c -s /var/lib/squid/ssl_db -M 4MB
chown -R proxy:proxy /var/lib/squid/ssl_db

echo " - Reiniciando squid (Esto va a tardar un poco...)"
systemctl restart squid
echo "[10] Conf. dhcp"
cp cosas/dhcp /etc/dhcp/dhcpd.conf -rvf
cp cosas/isc-default /etc/default/isc-dhcp-server -rvf
systemctl restart isc-dhcp-server

echo "[11] Conf. Nginx"
rm -rvf /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default
cp -rvf cosas/sitio /etc/nginx/sites-enabled/default
cp -rvf cosas/sitio /etc/nginx/sites-available/default
php_dir=$(ls -d /etc/php/[0-9].* 2>/dev/null | tail -n 1)
versionphp=$(basename "$php_dir")
cp -rvf /etc/squid/ssl_cert/squid_ca.pem /srv/certi.pem
ln -sf /srv/certi.pem /srv/alumnos/certi.pem
mysql < cosas/base_router.sql
echo -n "Introduce la nueva contraseña. NO SALDRA EN LA TERMINAL > "
read -s ncont
conthash=$(php -r "echo password_hash('$ncont', PASSWORD_BCRYPT);")
mysql -D router -e "UPDATE datoslogin SET contrahash = \"$conthash\" WHERE usuario = \"admin\";"
echo "www-data ALL=(ALL) NOPASSWD: /sbin/reboot" >> /etc/sudoers
systemctl restart nginx php$versionphp-fpm
echo "[12] Haciendo RADIUS"
cp -rvf cosas/radius-sitio-default /etc/freeradius/3.0/sites-enabled/default
cp -rvf cosas/radius-eap /etc/freeradius/3.0/mods-enabled/eap
cp -rvf cosas/sqlconfradius /etc/freeradius/3.0/mods-enabled/sql
mysql -e "CREATE DATABASE baseradius;"
mysql -e "CREATE USER 'Fran' IDENTIFIED BY 'FranPassword';"
mysql -e "GRANT ALL ON baseradius.* TO 'Fran';"
mysql -e "FLUSH PRIVILEGES;"
mysql -D baseradius < /etc/freeradius/3.0/mods-config/sql/main/mysql/schema.sql
for i in {1..5};
do
	PROF=prof$i
	CONT=$RANDOM$RANDOM$RANDOM
	echo "Agregando usuario $PROF con contraseña $CONT"
	mysql -u Fran -pFranPassword -D baseradius -e "INSERT INTO radcheck (username, attribute, op, value) VALUES ('$PROF', 'Cleartext-Password', ':=', '$CONT');"
done
i=0
for i in {1..50};
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

cd jmail/

echo "[13] Instalando JMAIL"
make instalar
echo "[+] Enviar correo (enviarcorreo)"
cp -rvf enviarcorreo.sh /usr/bin/enviarcorreo
chmod -Rvf +x /usr/bin/enviarcorreo

echo "[+] Enviar correo seguro (enviarcorreoseguro)"
cp -rvf enviarcorreoseguro.py /usr/bin/enviarcorreoseguro
chmod -Rvf +x /usr/bin/enviarcorreoseguro

echo "[+] Leer correo (leercorreo)"
cp -rvf leercorreo.sh /usr/bin/leercorreo
chmod -Rvf +x /usr/bin/leercorreo

echo "[+] Configuracion (jmail.conf)"
mkdir -p /etc/jmail
cp -rvf jmail.conf /etc/jmail/
echo "Configurando reglas de sudo..."
mkdir -p /etc/sudoers.d/
echo "www-data ALL=(ALL) NOPASSWD: /usr/bin/leerweb.sh" >> /etc/sudoers.d/jmail
chmod 440 /etc/sudoers.d/jmail -Rvf
echo "Instalando JQ para leer adjuntos"
DEBIAN_FRONTEND=noninteractive apt install jq -y -qq
echo "Copiando PHPs y activando el include"
cp -rvf leerweb.sh /usr/bin/
cp -rvf enviarcorreo.php /srv/
cp -rvf descargar.php /srv/
cp -rvf leercorreo.php /srv/
cp -rvf vercorreosusuario.php /srv/
cp -rvf jmail.php /srv/
cp -rvf adjunto.php /srv/
cat bashrc >> $HOME/.bashrc
echo "Copiando archivos..."
cp alertas.sh /usr/bin/alertas
chmod +x /usr/bin/alertas
cp alertas.service /etc/systemd/system/
systemctl reload-daemon
systemctl enable --now alertas

cd -

echo
echo "Asegurate de instalar tambien de ejecutar aux/backup.sh en al menos un cliente!"
