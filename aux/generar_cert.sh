#!/bin/bash

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


