#!/bin/bash
ArchAProbarAUX=("backup.sh" "crear_cuentas_sql.sh" "gen_acl.sh" "gen_variables.sh" generar_cert.sh generar_dhcp.sh generar_nginx.sh generar_red.sh generar_squid.sh instalar.sh iptables.sh jmail.sh mail.sh nginx.sh pers2.sh personalizaciones.sh radius.sh rootssh.sh)


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

echo "[+] Comprobando archivos ejecutables"
for i in "${ArchAProbarAUX[@]}"
do
	if [[ -x "aux/$i" ]]
	then
		echo "[+] Existe y es ejecutable: $i"
	else
		echo "[!] No existe o no es ejecutable: $i"
		error="$error \nError en $i (No existe o no es ejecutable)"
	fi
sleep 0.1
done



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

echo "Primero, este programa soporta configurar dinamicamente los servicios, ¿Quieres personalizar la instalacion? (Redes, filtros, interfaces de configuracion, DHCP...)"
read -p '(S)i, claro, hazme preguntas, ->(N)o, hazlo a tu manera :D -> [S/(N)] ? ' conf
	case $conf in
		S | s)
			echo
			echo "Genial, ahora se ejecutara el script de personalizacion, ten cuidado con tus respuestas, podras salir a un shell antes de continuar cuando acabes de personalizar"
			echo
			echo "Se configuraran las interfaces de red y el servidor dhcp"
			echo
			source aux/personalizaciones.sh
			echo
			echo "Has completado la configuracion, ahora vamos con las opciones miscelaneas, ten en cuenta que algunas de estas borraran tus opciones anteriores, o crearan conflictos, si no sabes lo que estas haciendo, rechaza todo"
			echo
			source aux/pers2.sh
			echo
			if [[ $interfaz == "no" ]]
			then
				echo "En el script anterior has seleccionado **NO** instalar la interfaz de config. Esto significa que NO se instalara nginx ni php ni se configurara el sitio."
			fi
			echo
			read -p '¿Quieres cambiar algo [S/(N)]? > ' editar
			if [[ $editar == "S" ]]
			then
				while true
				do
					echo "Parece que todo esta listo, ahora voy a dejar que edites los archivos a tu medida, escribe el nombre del archivo o escribe \"salir\" para salir del bucle"
					echo
					ls cosas/*.custom
					echo
					read -p "Archivo o salir ? > " editar
					if [[ $editar == "salir" ]]
					then
						break
					fi
					if [[ ! -f cosas/$editar ]]
					then
						echo
						echo "Whoops, eso no ha funcionado (No existe el archivo)"
						echo
					else
						nano cosas/$editar
					fi
				done
			fi
			echo
			echo "Ahora se generara la config de squid (basada en tus respuestas)"
			echo
			source aux/generar_squid.sh
			echo
			read -p "Se ha finalizado la parte de personalizacion, presiona enter para continuar con la instalacion"
			source root.sh
		;;
		*)
			echo "Perfecto entonces, se instalara todo con las configuracion por defecto!"
			echo "¡Buena suerte!"
			source pordefecto.sh
		;;
	esac

