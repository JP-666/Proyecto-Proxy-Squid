#!/bin/bash
# Si detecta que un alumno esta intentando entrar en un sitio "prohibido" nos avisa por jmail.

# El usuario que recibira los emails.
USUARIO=root

# Quien, o que, envia el mensaje. Por defecto se envia como "Servicio Squid", con su PID.
DE="Servicio Squid (PID: $(pidof squid))"

# Donde lo va a enviar
dir=127.0.0.1
# ... Y a que puerto
puerto=42069

tail -n 0 -f /var/log/squid/access.log  | grep --line-buffered "TCP_DENIED" | while read -r linea
do
	IP=$(echo "$linea" | awk '{print $3}')
	enlace=$(echo "$linea" | awk '{print $7}')
	tiempoahora=$(date "+%d/%m a las %H:%M:%S")

	msgaenviar="{
	\"MAIL\": {
			\"PARA\": \"$USUARIO\",
			\"DE\": \"$DE\",
			\"ASUNTO\": \"Advertencia sitio prohibido Squid para la IP $IP\",
			\"CUERPO\": \"La IP $IP ha intentado acceder el dia $tiempoahora a la direccion $enlace.\"
		}
	}
	HASTALAVISTABABY"

	echo $msgaenviar | nc -w 5 $dir $puerto
done
