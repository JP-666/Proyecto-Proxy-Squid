#!/bin/python3
# JMail pero seguro* (SJMail)
# *Seguro = "SSL"

import socket
import ssl
#import sys importlib.util # Todo lo que necesito para importar jmail


# Me queda importar guardar de jmail, pero como no tiene una extension .py no le gusta a python :c


context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
context.load_cert_chain(certfile="server.crt", keyfile="server.key") # Si no las tienes en tu maquina, las creas, o las copias de lo de squid, lo que te sal>
bind_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
bind_socket.bind(("0.0.0.0", 42068)) # Me queda: Permitir cambiar el puerto
bind_socket.listen(5) # En internet dicen que "5", supongo que es un ENUM para algo??



while True:
	try:
		newsocket, fromaddr = bind_socket.accept()
		conn = context.wrap_socket(newsocket, server_side=True)
		try:
			data = conn.recv(1024)
			print(f"Recibido: {data.decode()}")
			conn.sendall(b"Genial!")
			conn.close()
		except:
			print("Hubo un error")
	except KeyboardInterrupt: # "El excepto por defecto tiene que estar lo ultimo :nerd:"
		print("\rSaliendo...") # El carriage return para que no salga el ^C feo ese de pulsar CTRL-C
		exit()
	except:
		print("Error en la conexion con el cliente")

# Añadir un wrapper para leer los JSON y todo lo de HASTALAVISTA, o alternativamente redireccionarlo a el puerto 42069.
