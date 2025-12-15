#!/bin/bash

# ¡Ejecuta como root!

if [[ $UID != 0 ]]
then
	echo "Ejecutame como root!"
	exit
fi

if [[ ! $(basename $PWD) == "Proyecto-Proxy-Squid" ]]
then
	echo "Estas en la carpeta del proyecto?"
	echo "basename $PWD != Proyecto-Proxy-Squid"
	echo "Script en $(dirname $(which $0))"
	exit
fi

archint=cosas/interfaces
archdhcp=cosas/dhcp
archsitio=cosas/sitio
archsquid=cosas/squid.conf


read -p "¿Quieres que te haga muchas preguntas aburridas sobre todo (S) o que pase directo a la accion? (N) [(S)/N]> ? " preg

case $preg in
	N | n)
		echo "Ok! Vamos al tema!"
		cp -rvf srv / >&2
	;;
	*) # Hacemos todas las preguntas



		read -p "¿Quieres personalizar la configuración [S/(N)]> ? " opc

		case $opc in
			S | s)
				echo "Se procede a personalizar los archivos."
				source aux/personalizaciones.sh
			;;
			*)
				echo "Usando confs. por defecto"
			;;
		esac






		read -p "¿Instalar interfaz de config.? [(S)/N]> ? " ifazcon
		interfaz=si
		case $ifazcon in
			N | n)
				echo "Ok, no se configurara la interfaz de administracion"
				interfaz=no
			;;
			*) # (no no = si) Copiamos las cosas del sitio del "router"
				read -p "Permitir a los alumnos acceder a la interfaz de configuracion? [S/(N)] > ? " aluconf
				case $aluconf in
					S | s)
						echo "OK, aunque no deberias hacer esto."
						archsitio=cosas/sitio-ifazconfalum
						archsquid=cosas/squidal_profs
					;;
				esac
				echo "Copiando archivos" >&2
				cp -rvf srv / >&2
			;;
		esac



		read -p "¿Saldran los profesores al internet a traves del proxy, o no? [S/N] > " conf
		profesores=si
		case $conf in
			S | s)
				echo "La red de los profesores tambien pasara por el proxy"
			;;
			N | n)
				echo "La red de los profesores **NO** pasara por el proxy"
				profesores=no
			;;
			*)
				echo "?? Se asume que si..."
			;;
		esac











	;;
esac





if [[ ! -f "cosas/dhcp" ]]
then
	echo " - Falta la config del dhcp!"
	echo "FALTA cosas/dhcp (!)" >> $HOME/error.log
	error=true
fi

if [[ ! -f "cosas/interfaces" ]]
then 
	echo " - Falta la config de las interfaces!"
	echo "FALTA cosas/interfaces (!)" >> $HOME/error.log
	error=true
fi

if [[ ! -f "cosas/isc-default" ]]
then 
	echo " - Faltan los valores default del isc!!"
	echo "FALTA cosas/isc-default (!)" >> $HOME/error.log
	error=true
fi

if [[ ! -f "cosas/sitio" ]]
then 
	echo " - Falta la config del sitio de nginx!"
	echo "FALTA cosas/sitio (!)" >> $HOME/error.log
	error=true
fi

if [[ ! -f "cosas/squid.conf" ]]
then 
	echo " - Falta la config del squid!"
	echo "FALTA cosas/squid.conf (!)" >> $HOME/error.log
	error=true
fi

if [[ $error ]]
then
	read -p "Se han producido errores, quieres continuar de todos modos? [S/(N)] > " cont1


	case $cont1 in
		S | s)
			echo "Asegurate de arreglar los problemas luego! Se han enviado a tu carpeteta personal"
			source aux/personalizaciones.sh
		;;
		*)
			echo "Saliendo, comprueba los errores en tu carpeta personal"
			exit
		;;
	esac
fi








if [[ -f "cosas/interfaces.custom" ]]
then
	echo "Se usaran las interfaces personalizadas"
	archint=cosas/interfaces.custom
fi


if [[ -f "cosas/dhcp.custom" ]]
then
	echo "Se usaran los ajustes de dhcp personalizados"
	archdhcp=cosas/dhcp.custom
fi







read -p "Presiona intro para continuar"
