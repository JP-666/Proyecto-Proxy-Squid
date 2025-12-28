#!/bin/bash
# Si detecta que un alumno esta intentando entrar en un sitio "prohibido" nos avisa por jmail.


tail -f /var/log/squid/access.log  | grep --line-buffered "TCP_DENIED" | while read -r linea
do
	IP=$(echo "$linea" | awk '{print $3}')
	enlace=(echo "$linea" | awk '{print $7}')
	tiempoahora=$(date "+%d/%m a las %H:%M:%S")

	msgaenviar="{
	\"MAIL\": {
			\"PARA\": \"root\",
			\"DE\": \"admin\",
			\"ASUNTO\": \"Advertencia sitio prohibido Squid para la IP $IP\",
			\"CUERPO\": \"La IP $IP ha intentado acceder el dia $tiempoahora a la direccion $enlace.\"
		}
	}
	HASTALAVISTABABY"

	echo $msgaenviar | nc -w 5 127.0.0.1 42069
done
