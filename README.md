# ¿Que?
- Esto es una compilacion de scripts que instala un proxy squid super simple transparente (+SSL)

# ¿Como?

* Descarga https://github.com/JP-666/Proyecto-Proxy-Squid 
	* ```git clone https://github.com/JP-666/Proyecto-Proxy-Squid```
		* (Instala Git)
			* ```apt install git```
* Ejecuta 'main.sh'
	* Ah, como superusuario!
		* (Si no, no te preocupes, que te guarda las respuestas!)
# ¿Uh? (Notas)
- Asume que estas usando enp0s3 para la red 'real' y enp0s8 para la red 'interna'
- Asume que tu red (Principal, profesorado) es 10.0.0.0/24, si no es asi, cambia los archivos de configuracion o ejecuta el asistente dentro de "extras"
- El resto de redes (Alumnos 1 y Alumnos 2) tambien se pueden cambiar
