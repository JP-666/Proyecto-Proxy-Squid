#!/bin/bash

# Hace un servidor netboot.
# Este script se ejecuta desde otro auxiliar, el cual lo arranca como superusuario.

ISO="https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-13.2.0-amd64-xfce.iso"
ARCHIVO="debian-live-13.2.0-amd64-xfce.iso"

if [[ ! -v $router1 ]]
then
	echo "No se encuentra la variable router1 (La IP de este servidor)"
	read -p "Introduce la IP a usar para el resto del script (10.0.0.1) ? " ipnueva
else
	ipnueva=$router1
fi

if [[ ! -v $ipnueva ]]
then
	echo "Vale, vale, ahi va la ip 10.0.0.1"
	ipnueva=10.0.0.1
fi

if [[ $(read -p "¿Quieres actulizar tambien la lista de paquetes antes de iniciar? La de Debian 12 ya esta congelada, asi que no deberia hacer falta, pero por si acaso ? ([N]/S) ") == "S" ]]
then
	apt update
fi

echo
echo "Instalando pxelinux y utilidades..."
echo

apt install -y -qq pxelinux syslinux-common syslinux-utils p7zip-full tftpd-hpa nfs-kernel-server
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


mkdir -p /var/lib/tftpboot/pxelinux.cfg
cp -rvf /usr/lib/PXELINUX/pxelinux.0 /var/lib/tftpboot/
cp -rvf /usr/lib/syslinux/modules/bios/{ldlinux.c32,menu.c32,libutil.c32,libcom32.c32} /var/lib/tftpboot/
cp -rvf netboot/menu /var/lib/tftpboot/pxelinux.cfg/default

echo "    APPEND initrd=initrd.img boot=live netboot=nfs nfsroot=$ipnueva:/netboot/debian ip=dhcp splashtop" >> /var/lib/tftpboot/pxelinux.cfg/default

echo
echo "Descargando la iso..."
echo

wget -c $ISO -O $ARCHIVO # El -c por si se corta

echo
echo "Extrayendo archivos de la ISO de Debian..."
echo

7z e $ARCHIVO -o/var/lib/tftpboot/ live/vmlinuz live/initrd.img -y

mkdir -p /netboot/debian

echo "Descomprimiendo la ISO completa en /netboot/debian..."

7z x $ARCHIVO -o/netboot/debian/ -y

if ! grep -q "/netboot/debian" /etc/exports; then
    echo "/netboot/debian *(ro,sync,no_subtree_check,no_root_squash)" >> /etc/exports
fi

exportfs -ra
chmod -R 755 /netboot/debian

echo "Reiniciando servicios para aplicar cambios finales..."

systemctl restart nfs-kernel-server isc-dhcp-server tftpd-hpa

echo "¡Servidor listo para Debian Netboot!"
