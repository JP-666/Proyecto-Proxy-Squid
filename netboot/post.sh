#!/bin/bash
# ESTE SCRIPT ES PARA LOS CLIENTES!

apt update

wget http://10.0.0.1/certi.pem

cp certi.pem /usr/local/share/ca-certificates/certi_insti.crt
sleep 1
/sbin/update-ca-certificates


apt install make git python3 -y

GIT_SLL_NO_VERIFY=true git clone http://github.com/JP-666/Proyecto-Proxy-Squid
# Por que aun no tenemos el ssl

cd Proyecto-Proxy-Squid/jmail
make

cp -rvf enviarcorreo.sh /usr/bin/enviarcorreo
chmod -Rvf +x /usr/bin/enviarcorreo
cp -rvf leercorreo.sh /usr/bin/leercorreo
chmod -Rvf +x /usr/bin/leercorreo
cat bashrc >> /home/usuario01/.bashrc
cp -rvf enviarcorreoseguro.py /usr/bin/enviarcorreoseguro
chmod -Rvf +x /usr/bin/enviarcorreoseguro
mkdir -p /etc/jmail
cp -rvf jmail.conf /etc/jmail/


echo "PC del instituto" > /etc/motd

# Algunas pruebas
