#!/bin/python3
# JMail pero seguro* (SJMail)
# *Seguro = "SSL"

import socket
import ssl
import sys # Todo lo que necesito para importar jmail
import random
import os # Para lo de la 'acl'

# Me queda importar guardar de jmail, pero como no tiene una extension .py no le gusta a python :c
sys.path.append('/usr/bin/')
import jmail_comun



# Cargar la 'ACL'

if os.path.exists("/etc/jmail/jmail.conf"):
	print("Cargando ACL...")
	ips_den = []
	with open("/etc/jmail/jmail.conf", "r") as f:
		for linea in f:
			if linea.startswith("bloquear-ip"):
				ip = linea.split()[1]
				ips_den.append(ip)
				print(f"[+] {ip} añadida a la lista de IPs bloqueadas")
else:
	print("El archivo /etc/jmail/jmail.conf no existe! (O no se puede leer)")

context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
context.load_cert_chain(certfile="/etc/jmail/server.crt", keyfile="/etc/jmail/server.key") # Si no las tienes en tu maquina, las creas, o las copias de lo de squid, lo que te sal>
bind_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
bind_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
bind_socket.bind(("0.0.0.0", 42068)) # Me queda: Permitir cambiar el puerto
bind_socket.listen(5) # En internet dicen que "5", supongo que es un ENUM para algo??

CIERRE = b"HASTALAVISTABABY"
raw_data = b""



while True:
	try:
		newsocket, fromaddr = bind_socket.accept()
		conn = context.wrap_socket(newsocket, server_side=True)
		with conn:
			ip = fromaddr[0]
			if ip in ips_den:
				conn.sendall("No puedes enviar mensajes a este servidor.\n".encode("UTF-8"))
				print(f"Bloqueado de: {ip}")
			else:

				raw_data = b""
				while True:
					data = conn.recv(4096)
					if not data:
						break
					raw_data += data
					if raw_data.strip().endswith(CIERRE):
						raw_data = raw_data.strip()[:-len(CIERRE)]
						mensajeadios = jmail_comun.procesar(raw_data, ip)
						break
				if not mensajeadios:
					mensajeadios = random.choice(["SAYONARA", "CONSIDERA ESTO UN DIVORCIO", "VOLVERE!"])
				conn.sendall(f"\n{mensajeadios} (Se ha cerrado la conexion)\n".encode('utf-8'))


	except KeyboardInterrupt: # "El excepto por defecto tiene que estar lo ultimo :nerd:"
		print("\rSaliendo...") # El carriage return para que no salga el ^C feo ese de pulsar CTRL-C
		exit()
	except Exception as error:
		print(error)


# Añadir un wrapper para leer los JSON y todo lo de HASTALAVISTA, o alternativamente redireccionarlo a el puerto 42069.
