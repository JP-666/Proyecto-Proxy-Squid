#!/bin/bash

read -p "¿Instalar interfaz de config.? [(S)/N]> ? " ifazcon
	case $ifazcon in
		N | n)
			echo "Ok, no se configurara la interfaz de administracion"
			export interfaz=no
		;;
		*) # (no no = si) Copiamos las cosas del sitio del "router"
			read -p "Permitir a los alumnos acceder a la interfaz de configuracion? [S/(N)] > ? " aluconf
			case $aluconf in
				S | s)
					echo "OK, aunque no deberias hacer esto."
					export archsitio=cosas/sitio-ifazconfalum
					export archsquid=cosas/squidal_profs
				;;
			esac
			echo "Copiando archivos" >&2
			cp -rvf srv / >&2
		;;
	esac



	read -p "¿Saldran los profesores al internet a traves del proxy, o no? [S/N] > " conf
	export profesores=si
	case $conf in
		S | s)
			echo "La red de los profesores tambien pasara por el proxy"
		;;
		N | n)
			echo "La red de los profesores **NO** pasara por el proxy"
			export profesores=no
		;;
		*)
			echo "?? Se asume que si..."
		;;
	esac
