#!/bin/python3
# JMail pero seguro* (SJMail)
# *Seguro = "SSL"

import socket
import ssl
import sys # Todo lo que necesito para importar jmail
import random

# Me queda importar guardar de jmail, pero como no tiene una extension .py no le gusta a python :c
sys.path.append('/usr/bin/')
import jmail_comun


context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
context.load_cert_chain(certfile="/etc/jmail/server.crt", keyfile="/etc/jmail/server.key") # Si no las tienes en tu maquina, las creas, o las copias de lo de squid, lo que te sal>
bind_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
bind_socket.bind(("0.0.0.0", 42068)) # Me queda: Permitir cambiar el puerto
bind_socket.listen(5) # En internet dicen que "5", supongo que es un ENUM para algo??

CIERRE = b"HASTALAVISTABABY"
raw_data = b""



while True:
	try:
		newsocket, fromaddr = bind_socket.accept()
		conn = context.wrap_socket(newsocket, server_side=True)
		with conn:
			raw_data = b""
			while True:
				data = conn.recv(4096)
				if not data:
					break
				raw_data += data
				if raw_data.strip().endswith(CIERRE):
					raw_data = raw_data.strip()[:-len(CIERRE)]
					jmail_comun.procesar(raw_data, fromaddr[0])
					break
			mensajeadios = random.choice(["SAYONARA", "CONSIDERA ESTO UN DIVORCIO", "VOLVERE!"])
			conn.sendall(f"\n{mensajeadios} (Se ha cerrado la conexion)\n".encode('utf-8'))


	except KeyboardInterrupt: # "El excepto por defecto tiene que estar lo ultimo :nerd:"
		print("\rSaliendo...") # El carriage return para que no salga el ^C feo ese de pulsar CTRL-C
		exit()
	except Exception as error:
		print(error)


# Añadir un wrapper para leer los JSON y todo lo de HASTALAVISTA, o alternativamente redireccionarlo a el puerto 42069.
