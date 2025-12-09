#!/bin/bash

# Ejecuta como root!

if [[ $UID != 0 ]]
then
echo "Ejecutame como root!"
exit
fi

# Copiamos las cosas del sitio del "router"
cp srv /srv


# Prep. El sistema
echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf
sysctl -p



# Instala
apt install -y iptables squid-openssl iptables-persistent isc-dhcp-server nginx php-fpm openssh-server git

# Permite login del root en ssh
cat /usr/share/openssh/sshd_config | sed 's/\#PermitRootLogin prohibit-password/PermitRootLogin yes/g' > /etc/ssh/sshd_config; systemctl restart sshd



# Copiar configs
cp squid.conf /etc/squid/squid.conf
cp interfaces /etc/network/interfaces


# Configura IPTABLES
iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 80 -j REDIRECT --to-port 3128
iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 443 -j REDIRECT --to-port 3129

# Guarda las IPTABLES
netfilter-persistent save


# Crea todo lo que necesitamos para el SSL
mkdir -p /etc/squid/ssl_cert
chown proxy:proxy /etc/squid/ssl_cert
chmod 700 /etc/squid/ssl_cert
cd /etc/squid/ssl_cert

openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -keyout squid_ca.key -out squid_ca.pem -sha256 -subj "/C=ES/ST=Cadiz/L=Cadiz/O=Instituto/OU=squidinstituto/CN=CERTIFICADO PARA SSL DE SQUID DEL INSTITUTO"

chown proxy:proxy *

mkdir -p /var/lib/squid/

/usr/lib/squid/security_file_certgen -c -s /var/lib/squid/ssl_db -M 4MB

chown -R proxy:proxy /var/lib/squid/ssl_db





# Configuramos el dhcp



cat << EOF > /etc/dhcp/dhcpd.conf
ddns-update-style none;
default-lease-time 600;
max-lease-time 7200;
authoritative;

subnet 10.0.0.0 netmask 255.255.255.0 {
range 10.0.0.100 10.0.0.200;
option domain-name-servers 8.8.8.8, 8.8.4.4;
option domain-name "redinsti";
option routers 10.0.0.1;
option broadcast-address 10.0.0.255;
default-lease-time 600;
max-lease-time 7200;
}
EOF


cat << EOF > /etc/default/isc-dhcp-server
INTERFACESv4="enp0s8"
INTERFACESv6=""
EOF




cat << EOF > /etc/nginx/sites-available/default
server {
listen 80 default_server;

root /srv/;
index index.php;

location / {
try_files \$uri \$uri/ =404;
}

location ~ \.php$ {
include snippets/fastcgi-php.conf; # Esto es para php-fpm 8.2, la que viene con Debian 12, cambia a tu gusto.
fastcgi_pass unix:/run/php/php8.2-fpm.sock;
}

}
EOF


ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
systemctl restart isc-dhcp-server nginx php8.2-fpm


# Copiamos el certificado para descarga
cp /etc/squid/ssl_cert/squid_ca.pem /srv/certi.pem
