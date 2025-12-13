#!/bin/bash

# ¡Ejecuta como root!

if [[ $UID != 0 ]]
then
	echo "Ejecutame como root!"
	exit
fi

if [[ ! $(basename $PWD) == "Proyecto-Proxy-Squid" ]]
then
	echo "Estas en la carpeta del proyecto?"
	echo "basename $PWD != Proyecto-Proxy-Squid"
	echo "Script en $(dirname $(which $0))"
	exit
fi

if [[ ! -f "cosas/dhcp" ]]
then
	echo " - Falta la config del dhcp!"
	echo "FALTA cosas/dhcp (!)" >> $HOME/error.log
	error=true
fi

if [[ ! -f "cosas/interfaces" ]]
then 
	echo " - Falta la config de las interfaces!"
	echo "FALTA cosas/interfaces (!)" >> $HOME/error.log
	error=true
fi

if [[ ! -f "cosas/isc-default" ]]
then 
	echo " - Faltan los valores default del isc!!"
	echo "FALTA cosas/isc-default (!)" >> $HOME/error.log
	error=true
fi

if [[ ! -f "cosas/sitio" ]]
then 
	echo " - Falta la config del sitio de nginx!"
	echo "FALTA cosas/sitio (!)" >> $HOME/error.log
	error=true
fi

if [[ ! -f "cosas/squid.conf" ]]
then 
	echo " - Falta la config del squid!"
	echo "FALTA cosas/squid.conf (!)" >> $HOME/error.log
	error=true
fi

if [[ $error ]]
then
	read -p "Se han producido errores, quieres continuar de todos modos? [S/(N)] > " cont1


	case $cont1 in
		S | s)
			echo "Asegurate de arreglar los problemas luego! Se han enviado a tu carpeteta personal"
			source aux/personalizaciones.sh
		;;
		*)
			echo "Saliendo, comprueba los errores en tu carpeta personal"
			exit
		;;
	esac
fi


read -p "¿Quieres personalizar la configuración [S/N]> ? " opc

case $opc in
	S | s)
		echo "Se procede a personalizar los archivos."
		source aux/personalizaciones.sh
	;;
	N | n)
		echo "Usando confs. por defecto"
	;;
	*)
		echo "?? Se asume que no..."
	;;
esac


archint=cosas/interfaces
archdhcp=cosas/dhcp

if [[ -f "cosas/interfaces.custom" ]]
then
	echo "Se usaran las interfaces personalizadas"
	archint=cosas/interfaces.custom
fi


if [[ -f "cosas/dhcp.custom" ]]
then
	echo "Se usaran los ajustes de dhcp personalizados"
	archdhcp=cosas/dhcp.custom
fi

read -p "¿Saldran los profesores al internet a traves del proxy, o no? [S/N] > " conf
profesores=si
case $conf in
	S | s)
		echo "La red de los profesores tambien pasara por el proxy"
	;;
	N | n)
		echo "La red de los profesores **NO** pasara por el proxy"
		profesores=no
	;;
	*)
		echo "?? Se asume que si..."
	;;
esac

# Copiamos las cosas del sitio del "router"
echo "Copiando archivos" >&2
cp -rvf srv / >&2

read -p "Presiona intro para continuar"

# Prep. El sistema
echo "Preparando el sistema" >&2
echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf
sysctl -p

read -p "Presiona intro para continuar"

echo "Copiando y conf. red"
cp $archint /etc/network/interfaces -rvf
systemctl restart networking

# Instala

echo "Iniciando la instalacion, esto puede tardar un ratito..." >&2

apt update

read -p "La instalacion va a dar un error de isc-dhcp-server, esto es NORMAL y se espera que pase, simplemente sigue con la instalacion"

apt install -y iptables squid-openssl iptables-persistent isc-dhcp-server nginx php-fpm openssh-server git

read -p "Presiona intro para continuar"


echo "Ahora se permite iniciar sesion con contraseña como root por ssh" >&2
# Permite login del root en ssh
cat /usr/share/openssh/sshd_config | sed 's/\#PermitRootLogin prohibit-password/PermitRootLogin yes/g' > /etc/ssh/sshd_config; systemctl restart sshd

read -p "Presiona intro para continuar"



# Copiar configs
cp cosas/squid.conf /etc/squid/squid.conf -rvf

read -p "Presiona intro para continuar"

echo "Haciendo IPTABLES"
# Configura IPTABLES
iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
# Red prof
iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 80 -j REDIRECT --to-port 3128
iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 443 -j REDIRECT --to-port 3129
# Red Al1
iptables -t nat -A PREROUTING -i enp0s9 -p tcp --dport 80 -j REDIRECT --to-port 3128
iptables -t nat -A PREROUTING -i enp0s9 -p tcp --dport 443 -j REDIRECT --to-port 3129
# Red Al2
iptables -t nat -A PREROUTING -i enp0s10 -p tcp --dport 80 -j REDIRECT --to-port 3128
iptables -t nat -A PREROUTING -i enp0s10 -p tcp --dport 443 -j REDIRECT --to-port 3129

read -p "Presiona intro para continuar"

echo "Guardando las IPTABLES"
# Guarda las IPTABLES
netfilter-persistent save

read -p "Presiona intro para continuar"


# Crea todo lo que necesitamos para el SSL
echo "Creando dirs squid proxy"

mkdir -p /etc/squid/ssl_cert
chown proxy:proxy /etc/squid/ssl_cert
chmod 700 /etc/squid/ssl_cert
cd /etc/squid/ssl_cert

pais=ES
reg=Andalucia
ins=Instituto
org=squidinstituto
extra="CERTIFICADO PARA SSL DE SQUID DEL INSTITUTO"
read -p "Pais ? (Corto, p.e: ES) ? > " pais
read -p "Region ? (p.e: Andalucia) ? > " reg
read -p "Institucion ? (p.e: Instituto) ? > " ins
read -p "Organizacion ? (p.e: InstitutoXYZ) ? > " org
read -p "Extra ? (p.e: Mi certificado para lo que sea) ? > " extra



openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -keyout squid_ca.key -out squid_ca.pem -sha256 -subj "/C=$pais/ST=$reg/L=$reg/O=$ins/OU=$org/CN=$extra"

chown proxy:proxy *

mkdir -p /var/lib/squid/

/usr/lib/squid/security_file_certgen -c -s /var/lib/squid/ssl_db -M 4MB

chown -R proxy:proxy /var/lib/squid/ssl_db



read -p "Presiona intro para continuar"





# Copiamos los archivos de conf.

cd - # Volvemos a donde estabamos

cp $archdhcp /etc/dhcp/dhcpd.conf -rvf

cp cosas/isc-default /etc/default/isc-dhcp-server -rvf

cp cosas/sitio /etc/nginx/sites-available/default -rvf

ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

cd /bin
versionphp=$(ls php7* || ls php8* || ls php9* || ls php6* || ls php5* || ls php4* || ls php3* || ls php2* || echo "No se ha encontrado PHP!")

systemctl restart isc-dhcp-server nginx $versionphp-fpm squid
# Solo teniamos que reiniciar squid :D


# Copiamos el certificado para descarga
cp -rvf /etc/squid/ssl_cert/squid_ca.pem /srv/certi.pem
ln -sf /srv/certi.pem /srv/alumnos/certi.pem
