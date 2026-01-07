#!/bin/bash

# Hace un servidor netboot.
# Este script se ejecuta desde otro auxiliar, el cual lo arranca como superusuario.

NB="https://deb.debian.org/debian/dists/stable/main/installer-amd64/current/images/netboot/netboot.tar.gz"

echo
echo "Este script instalara Debian 13 a traves de pxelinux."
echo "Si quieres usar iVentoy para instalar el sistema 'MX Linux personaliazado'"
echo "Debes seguir las instrucciones en: https://cristobal.wiki/Netboot/iVentoy"
echo "Pero, ten en cuenta, que iVentoy es un programa 'closed-source'"
echo "Y no se sabe lo que hace al sistema operativo que esta instalando"
echo "Advertencia completa en https://cristobal.wiki/Netboot"
echo

echo
echo "Instalando pxelinux y utilidades..."
echo

apt install -y -qq pxelinux syslinux-common syslinux-utils tftpd-hpa whois # Whois trae el comando "mkpasswd"

# Se puede montando la ISO, pero asi es mas 'rapido'.

echo
echo "Configurando el servidor DHCP y el servidor tftp"
echo

cp -rvf netboot/conf_tftp /etc/default/tftpd-hpa
# La config de tftp

echo "" >> /etc/dhcp/dhcpd.conf # Una nueva linea para separar
echo "allow booting;" >> /etc/dhcp/dhcpd.conf
echo "allow bootp;" >> /etc/dhcp/dhcpd.conf
echo "next-server $ipnueva;" >> /etc/dhcp/dhcpd.conf
echo "filename \"pxelinux.0\";" >> /etc/dhcp/dhcpd.conf


echo "Copiando todo lo de PXE y añadiendo el archivo de configuracion"

mkdir -p /var/lib/tftpboot/

cd /var/lib/tftpboot/

wget $NB # El -c por si se corta

tar -xvf netboot.tar.gz

cd -

cp netboot/menu /var/lib/tftpboot/debian-installer/amd64/boot-screens/txt.cfg
echo "    APPEND initrd=debian-installer/amd64/initrd.gz auto=true priority=critical locale=es_ES.UTF-8 keymap=es preseed/url=http://10.0.0.1/pre.cfg --- quiet" >> /var/lib/tftpboot/debian-installer/amd64/boot-screens/txt.cfg
#																Cambia esto por la IP, si cambia.

aux/gen_pre.sh
cp cosas/pre.cfg /srv/pre.cfg
cp netboot/post.sh /srv/

echo "Reiniciando servicios para aplicar cambios finales..."

systemctl restart isc-dhcp-server tftpd-hpa

echo "¡Servidor listo para Debian Netboot!"
