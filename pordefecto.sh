#!/bin/bash
archint=cosas/interfaces
archdhcp=cosas/dhcp
archsitio=cosas/sitio
archsquid=cosas/squid.conf
echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf
sysctl -p
cp -rvf srv / >&2
cp $archint /etc/network/interfaces -rvf
systemctl restart networking
apt update
apt install -y iptables squid-openssl iptables-persistent isc-dhcp-server nginx php-fpm openssh-server git
cat /usr/share/openssh/sshd_config | sed 's/\#PermitRootLogin prohibit-password/PermitRootLogin yes/g' > /etc/ssh/sshd_config; systemctl restart sshd
cp $archsquid /etc/squid/squid.conf -rvf
iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 80 -j REDIRECT --to-port 3128
iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 443 -j REDIRECT --to-port 3129
iptables -t nat -A PREROUTING -i enp0s9 -p tcp --dport 80 -j REDIRECT --to-port 3128
iptables -t nat -A PREROUTING -i enp0s9 -p tcp --dport 443 -j REDIRECT --to-port 3129
iptables -t nat -A PREROUTING -i enp0s10 -p tcp --dport 80 -j REDIRECT --to-port 3128
iptables -t nat -A PREROUTING -i enp0s10 -p tcp --dport 443 -j REDIRECT --to-port 3129
netfilter-persistent save
mkdir -p /etc/squid/ssl_cert
chmod 700 /etc/squid/ssl_cert
cd /etc/squid/ssl_cert
openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -keyout squid_ca.key -out squid_ca.pem -sha256 -subj "/C=ES/ST=Andalucia/L=Andalucia/O=Instituto/OU=squidinstituto/CN=CERTIFICADO PARA SSL DE SQUID DEL INSTITUTO"
chown proxy:proxy . -Rvf
mkdir -p /var/lib/squid/
/usr/lib/squid/security_file_certgen -c -s /var/lib/squid/ssl_db -M 4MB
chown -R proxy:proxy /var/lib/squid/ssl_db
cd -
cp $archdhcp /etc/dhcp/dhcpd.conf -rvf
cp cosas/isc-default /etc/default/isc-dhcp-server -rvf
cp $archsitio /etc/nginx/sites-available/default -rvf
ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
cd /bin
versionphp=$(ls php7* || ls php8* || ls php9* || ls php6* || ls php5* || ls php4* || ls php3* || ls php2* || echo "No se ha encontrado PHP!")
cp -rvf /etc/squid/ssl_cert/squid_ca.pem /srv/certi.pem
ln -sf /srv/certi.pem /srv/alumnos/certi.pem
systemctl restart isc-dhcp-server nginx $versionphp-fpm squid
