#!/bin/bash
# El script se instala como superusuario por defecto. Por que es llamado desde el script principal

cd jmail/

echo "[13] Instalando JMAIL"
echo ""
read -p 'Instalar JMail? (Servidor) ([S]/N) ? > ' servidor

if [[ ! "$servidor" =~ ^[Nn]$ ]] # Con regex, cualquier "N" o "n".
then
	make instalar
else
	echo "Te estas saltando la instalacion del servidor de JMail <!>"
fi

read -p 'Instalar clientes lectura/escritura para JMail? (Servidor) ([S]/N) ? > ' clientes

if [[ ! $clientes =~ ^[Nn]$ ]]
then
	echo "[+] Enviar correo (enviarcorreo)"
	cp -rvf enviarcorreo.sh /usr/bin/enviarcorreo
	chmod -Rvf +x /usr/bin/enviarcorreo
	echo "[+] Leer correo (leercorreo)"
	cp -rvf leercorreo.sh /usr/bin/leercorreo
	chmod -Rvf +x /usr/bin/leercorreo
else
	echo "Ok, puedes usar \"nc (IP) 42069\" para comunicarte con el servidor manualmente, y puedes explorar /jmail/$USER manualmente."
fi

read -p 'Configurar la interfaz web para que pueda enviar/leer JMails? ([S]/N) ? > ' ifaz


if [[ ! $ifaz =~ ^[Nn]$ ]]
then
	echo "Configurando reglas de sudo..."
	mkdir -p /etc/sudoers.d/
	echo "www-data ALL=(ALL) NOPASSWD: /usr/bin/leerweb.sh" >> /etc/sudoers.d/jmail
	chmod 440 /etc/sudoers.d/jmail -Rvf
	echo "Copiando PHPs y activando el include"
	cp -rvf leerweb.sh /usr/bin/
	cp -rvf enviarcorreo.php /srv/
	cp -rvf descargar.php /srv/
	cp -rvf leercorreo.php /srv/
	cp -rvf vercorreosusuario.php /srv/
	cp -rvf jmail.php /srv/
	# El include jmail.php ya esta puesto en el index.php, solo lo carga si lo tenemos
else
	echo "Ok, no se instalara en la interfaz."
fi

read -p 'Configurar avisos de JMail en BASH? ([S]/N) ? > ' bashjmail

if [[ ! $bashjmail =~ ^[Nn]$ ]]
then
	cat bashrc >> $HOME/.bashrc
	echo "Solo se instalara en tu usuario, añadelo a los usuarios que quieras usando cat bashrc >> $$HOME/.bashrc"
else
	echo "Ok, lo tienes en el archivo \"bashrc\" por si lo quieres hacer luego"
fi

read -p 'Activar envios de JMAIL para Squid Proxy? ([S]/N) ? > ' squid

if [[ ! $squid =~ ^[Nn]$ ]]
then
	echo "Copiando archivos..."
	cp alertas.sh /usr/bin/alertas
	chmod +x /usr/bin/alertas
	cp alertas.service /etc/systemd/system/
	systemctl reload-daemon
	systemctl start alertas
else
	echo "Ok, lo puedes hacer instalando el servicio de SystemD"
fi

