#!/bin/bash

# Hace un servidor netboot.
# Este script se ejecuta desde otro auxiliar, el cual lo arranca como superusuario.

ISO="https://ftp.cica.es/mirrors/Linux/MX-ISOs/MX/Final/Xfce/MX-25_Xfce_x64.iso"

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
else

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

echo "    APPEND initrd=initrd.gz root=/dev/nfs nfsroot=$ipnueva:/netboot/mxlinux boot=antiX disable=fstab nosplash" >> /var/lib/tftpboot/pxelinux.cfg/default

echo
echo "Descargando la iso..."
echo

wget $ISO


echo
echo "Extrayendo archivos de la ISO..."
echo
7z e mxlinux.iso -o/var/lib/tftpboot/ antiX/vmlinuz antiX/initrd.gz -y

mkdir -p /netboot/mxlinux
echo "Descomprimiendo la ISO completa en /netboot/mxlinux (esto VA A TARDAR)..."
7z x mxlinux.iso -o/netboot/mxlinux/ -y

echo "/netboot/mxlinux *(ro,sync,no_subtree_check,no_root_squash)" >> /etc/exports


exportfs -ra
chmod -R 755 /netboot/mxlinux

echo "Reiniciando servicios para aplicar cambios finales..."
systemctl restart nfs-kernel-server isc-dhcp-server tftpd-hpa
