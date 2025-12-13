#!/bin/bash

if [[ $UID != 0 ]]
then
	echo "##########################################################################################"
	echo "##########################################################################################"
	echo "##########################################################################################"
	echo "NO ESTAS ACCEDIENDO COMO ROOT!"
	echo "Esto puede causar problemas, algunas funciones no estaran disponibles"
	echo "##########################################################################################"
	echo "##########################################################################################"
	echo "##########################################################################################"
	export noroot=true
	echo
fi


if [[ ! $(basename $PWD) == "Proyecto-Proxy-Squid" ]]
then
	echo "Estas en la carpeta del proyecto?"
	echo "basename $PWD != Proyecto-Proxy-Squid"
	echo "Script en $(dirname $(which $0))"
	exit
fi

echo "##############################################"
echo "###               Mega-Script              ###"
echo "###               Instalacion              ###"
echo "##############################################"
echo
echo "A continuacion se seguiran una serie de pasos:"
echo "	1. Configurar el script (conf.sh)"
echo "	2. Instalar los paquetes necesarios (instalar.sh)"
echo "	3. "
echo "	4. "
echo ""

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
		;;
		*)
			echo "Perfecto entonces, se instalara todo con las configuracion por defecto!"
			echo "Buena suerte!"
			source todo-final.sh
		;;
	esac

