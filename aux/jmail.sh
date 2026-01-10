#!/bin/bash
jm=(adjunto.php alertas.sh borrar.php enviarcorreo.php enviarcorreo.sh jmail.conf jmail.php leercorreo.php leerweb.sh README.md sjmail.service vercorreosusuario.php alertas.service bashrc descargar.php enviarcorreoseguro.py jmail_comun.py jmail.json jmail.service leercorreo.sh Makefile server.py sserver.py)
if [[ ! $(basename $PWD) == "Proyecto-Proxy-Squid" ]]
then
	echo "No estas en la carpeta base"
	exit
fi
if [[ $UID != 0 ]]
then
	echo "No eres superusuario"
	exit
fi
for i in "${jm[@]}"
do
	if [[ ! -f "jmail/$i" ]]
	then
		echo "[!] No existe: $i"
		exit
	fi
done
if [[ -d /srv/ ]]
then
	mkdir -p /etc/sudoers.d/
	echo "www-data ALL=(ALL) NOPASSWD: /usr/bin/leerweb.sh" >> /etc/sudoers.d/jmail
	chmod 440 /etc/sudoers.d/jmail -Rvf
	cp -rf  leerweb.sh /usr/bin/
	chmod +x /usr/bin/leerweb.sh
	cp -rf  enviarcorreo.php /srv/
	cp -rf  descargar.php /srv/
	cp -rf  leercorreo.php /srv/
	cp -rf  vercorreosusuario.php /srv/
	cp -rf  jmail.php /srv/
	cp -rf  borrar.php /srv/
	cp -rf  adjunto.php /srv/
	cp -rf alertas.sh /usr/bin/alertas
	chmod +x /usr/bin/alertas
	cp -rf alertas.service /etc/systemd/system/
	systemctl daemon-reload
	systemctl enable --now alertas
fi
cd jmail/
mkdir -p /etc/jmail
cp -rf jmail.conf /etc/jmail/
sleep 0.2
make instalar
cp -rf enviarcorreo.sh /usr/bin/enviarcorreo
chmod +x /usr/bin/enviarcorreo
cp -rf enviarcorreoseguro.py /usr/bin/enviarcorreoseguro
chmod +x /usr/bin/enviarcorreoseguro
cp -rf leercorreo.sh /usr/bin/leercorreo
chmod +x /usr/bin/leercorreo
cat bashrc >> $HOME/.bashrc
