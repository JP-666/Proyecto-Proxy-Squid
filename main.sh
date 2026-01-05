#!/bin/bash
echo
echo "Se va a proceder a comprobar unos requisitos... Por favor, espera"
echo
echo "[+] Test Superusuario"
if [[ $UID != 0 ]]
then
	error="\nNo eres superusuario"
	echo "[!] Superusuario: No"
else
	echo "[+] Superusuario: Si"
fi
sleep 0.1 # Los sleeps para que el usuario vea lo que va pasando
echo "[+] Comprobando estructura de carpetas..."

if [[ ! $(basename $PWD) == "Proyecto-Proxy-Squid" ]]
then
	error="No estas en la carpeta base\n"
	echo "[!] Ubicacion: Mal"
else
	echo "[+] Pareces estar en la carpeta correcta"
fi
sleep 0.1

if [[ ! -f "extras/coco.jpeg" ]]
then
	echo "[!] Coco: No"
	error="\n$error Falta archivo integral 'extras/coco.jpeg'"
else
	echo "[+] coco.jpeg presente"
fi



if [[ ! -z $error ]]
then
	echo "Se han encontrado errores:"
	echo -e $error
	exit
fi

echo
echo
echo
echo "##############################################"
echo "###               Mega-Script              ###"
echo "###               Instalacion              ###"
echo "##############################################"
echo
echo "A continuacion se seguiran una serie de pasos:"
echo "	1. Personalizar la instalacion"
echo "	2. Generar configuraciones externas (SQUID, NGINX)"
echo "	3. Instalar los paquetes necesarios"
echo "	4. Configurar IPTABLES"
echo "	5. Permitir loguearse como root con contraseña a traves de SSH (OPCIONAL)"
echo "	6. Configurar el sistema (sysctl)"
echo "	7. Instalar la interfaz (OPCIONAL)"
echo "	8. Configurar la red"
echo "	9. Configurar SQUID (Y sus ACL (OPCIONALES))"
echo "	10. Configurar el servidor DHCP"
echo "	11. Configurar RADIUS"
echo # SON TABULADORES, NO ESPACIOS, QUE SI NO, SE QUEDAN RARO.
echo
source root.sh

