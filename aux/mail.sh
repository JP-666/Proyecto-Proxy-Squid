#!/bin/bash

if [[ $UID != 0 ]]
then
	echo "Vuelve como root!"
	exit
fi


DEBIAN_FRONTEND=noninteractive apt install -y -qq opensmtpd mailutils swaks
cp /etc/smtpd.conf /etc/smtpd.conf.bak
cp cosas/smtpd.conf /etc/
systemctl stop opensmtpd.service
systemctl enable --now opensmtpd.service

echo "Todo listo, usa el comando siguiente para probarlo:"
echo
echo "echo test | mail -s 'Test' root"
echo
echo "Alternativamente, usa swaks con el comando:"
echo
echo "swaks --from root --to root --server 127.0.0.1"
echo
