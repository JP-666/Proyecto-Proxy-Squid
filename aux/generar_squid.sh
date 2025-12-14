#!/bin/bash
echo > cosas/squid.custom

if [[ $profesores == "no" ]]
then
	echo "# Opcion: Profesores no salen por proxy" >> cosas/squid.custom
else
	echo "# Opcion: Profesores salen por proxy" >> cosas/squid.custom
fi

if [[ ! $aluconf == "no" ]]
then
	echo "# Opcion: Alumnos pueden acceder al router de los profesores ($router1)" >> cosas/squid.custom
else
	echo "# Opcion: Alumnos NO PUEDEN acceder al router de los profesores ($router1)" >> cosas/squid.custom
fi

echo "# Opcion: Red profesores: $red1" >> cosas/squid.custom
echo "# Opcion: Red alumnos 1: $red2" >> cosas/squid.custom
echo "# Opcion: Red alumnos 2: $red3" >> cosas/squid.custom





echo "" >> cosas/squid.custom

if [[ ! $profesores == "no" ]]
then
	echo "acl localnet src $red1/24" >> cosas/squid.custom
fi
echo "acl clase1 src $red2/24" >> cosas/squid.custom
echo "acl clase2 src $red3/24" >> cosas/squid.custom
if [[ $aluconf == "no" ]]
then
	echo "acl iprouterprofesores dst $router1" >> cosas/squid.custom
fi
echo "acl SSL_ports port 443 563" >> cosas/squid.custom
echo "acl Safe_ports port 80" >> cosas/squid.custom
echo "acl Safe_ports port 443" >> cosas/squid.custom
echo "acl CONNECT method CONNECT" >> cosas/squid.custom
echo "http_port 3127" >> cosas/squid.custom
echo "http_port 3128 intercept" >> cosas/squid.custom
echo "https_port 3129 intercept ssl-bump cert=/etc/squid/ssl_cert/squid_ca.pem key=/etc/squid/ssl_cert/squid_ca.key generate-host-certificates=on dynamic_cert_mem_cache_size=4MB" >> cosas/squid.custom
echo "sslcrtd_program /usr/lib/squid/security_file_certgen -s /var/lib/squid/ssl_db -M 4MB" >> cosas/squid.custom
echo "acl step1 at_step SslBump1" >> cosas/squid.custom
echo "ssl_bump peek step1" >> cosas/squid.custom
echo "ssl_bump bump all" >> cosas/squid.custom
if [[ $aluconf == "no" ]]
then
	echo "http_access deny iprouterprofesores clase1" >> cosas/squid.custom
	echo "http_access deny iprouterprofesores clase2" >> cosas/squid.custom
fi
if [[ ! $profesores == "no" ]]
then
	echo "http_access allow localnet" >> cosas/squid.custom
fi
echo "http_access allow clase1" >> cosas/squid.custom
echo "http_access allow clase2" >> cosas/squid.custom
echo "http_access deny all" >> cosas/squid.custom
echo "dns_nameservers 8.8.8.8 8.8.4.4" >> cosas/squid.custom



echo ""
echo "Generado un nuevo archivo de conf. de squid"
echo ""
echo ""
cat cosas/squid.custom
