echo
echo "[1] Instalacion"
echo
source aux/instalar.sh
echo
echo "[2] IPTABLES"
echo
source aux/iptables.sh
echo
echo
echo
# Pregunta sobre root
echo "[3] SSH - Root"
read -p 'Permitir conexiones SSH como superusuario con contraseña  -> [(S)/N] ? ' sup
case $sup in
	N | n)
		$SHELL aux/rootssh.sh # No tenemos que sourcearlo, no tiene ninguna variable ni nada
	;;
	*)
		echo "Continuando sin permitir login como root con contraseña..."
	;;
esac
echo "[4] Forwarding"
echo
echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf
sysctl -p
echo
echo "--- Ahora se configurara el servicio DHCP, las interfaces de red y se copiaran los archivos ---"
echo
echo "[5] Copiando archivos de /srv/"
cp -rvf srv / >&2
echo
echo "[6] Asignaciones de variables!"
if [[ -f cosas/interfaces.custom ]]; then archint=cosas/interfaces.custom; echo "Interfaces personalizadas"; else archint=cosas/interfaces; echo "Interfaces por defecto"; fi
if [[ -f cosas/dhcp.custom ]]; then archdhcp=cosas/dhcp.custom; echo "DHCP personalizado"; else archdhcp=cosas/interfaces; echo "dhcp por defecto"; fi
if [[ -f cosas/squid.custom ]]; then archsquid=cosas/squid.custom; echo "Squid personalizado"; else archsquid=cosas/squid.conf; echo "Squid por defecto"; fi
if [[ -f cosas/sitio.custom ]]; then archsitio=cosas/sitio.custom; echo "Config de nginx personalizado"; else archsitio=cosas/sitio; echo "Conf de nginx por defecto"; fi
echo "[7] Conf. Red"
cp $archint /etc/network/interfaces -rvf
echo " - Reiniciando red"
systemctl restart networking
echo "[8] Copiando squid"
cp $archsquid /etc/squid/squid.conf -rvf
echo "[9] Creando certificados"
echo
aux/generar_cert.sh
echo
echo " - Reiniciando squid"
systemctl restart squid
echo
echo "[10] Conf. dhcp"
cp $archdhcp /etc/dhcp/dhcpd.conf -rvf
cp cosas/isc-default /etc/default/isc-dhcp-server -rvf
systemctl restart isc-dhcp-server
if [[ ! $interfaz == "no" ]]
then
	echo "[11] Conf. Nginx"
	ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
	cd /bin
	versionphp=$(ls php7* || ls php8* || ls php9* || ls php6* || ls php5* || ls php4* || ls php3* || ls php2* || echo "No se ha encontrado PHP!")
	cp -rvf /etc/squid/ssl_cert/squid_ca.pem /srv/certi.pem
	ln -sf /srv/certi.pem /srv/alumnos/certi.pem
	systemctl restart nginx $versionphp-fpm
	cd -
else
	echo "Se ha saltado la instalacion de NGINX, tal como has pedido"
fi
