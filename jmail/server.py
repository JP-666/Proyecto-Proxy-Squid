#!/bin/python3
import socket
import os
import json
import pwd
from datetime import datetime
import shutil
import random # Esto lo tengo aqui para que seleccione de la lista de mensajes de "despedida"
import sys
sys.path.append('/usr/bin/')
import jmail_comun

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


IP_ESCUCHA = "0.0.0.0" # Todas las interfaces = 0.0.0.0, bloquear a una interfaz = (IP)
PUERTO = 42069 # Puedes cambiar esto, pero avisa a los clientes
BASE_DIR = "/jmail/" # JMAIL por que... Bueno, Gmail, pero J de Jua... Bueno, creo que lo pillas... ¿No?
CIERRE = b"HASTALAVISTABABY" # Esto es lo que cierra el "correo"


# Crear carpeta base, la puedes cambiar arriba, aunque no se por que querrias (¿?¿?)
os.makedirs(BASE_DIR, exist_ok=True)

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server:
	server.bind((IP_ESCUCHA, PUERTO)) # Esto pasa en segundo plano
	server.listen() # Y esto tambien pasa en segundo plano. Tenemos que MATARLO AL ACABAR! NO DEJAR SIN MATAR. MATAR MATAR MATAR MUERE MUERE MUEREEEEEEEEEEEEEEE!
	print(f"J-Mail Server Activo en puerto {PUERTO}...")
	print("Presiona CTRL+C para detener el servidor.")

	try:
		while True:
			conn, addr = server.accept()
			client_ip = addr[0]
			with conn:
				if client_ip in ips_den:
					conn.sendall("No puedes enviar mensajes a este servidor.\n".encode("UTF-8"))
					print(f"Bloqueado de: {ip}")
				else:
					conn.sendall("HABLALE A LA MANO\n\n".encode('utf-8'))
					raw_data = b""
					while True:
						data = conn.recv(4096)
						if not data:
							break
						raw_data += data
						if raw_data.strip().endswith(CIERRE):
							# Limpiamos el cierre del JSON (usamos len para ser exactos)
							raw_data = raw_data.strip()[:-len(CIERRE)]
							break
					mensajeadios = jmail_comun.procesar(raw_data, client_ip)
					if not mensajeadios:
						mensajeadios = random.choice(["SAYONARA", "CONSIDERA ESTO UN DIVORCIO", "VOLVERE!"])
				try:
					conn.sendall(f"\n{mensajeadios} (Se ha cerrado la conexion)\n".encode('utf-8'))
				except: # Si cierra la puerta (conexion) en la cara. O si el puerto esta bloqueado.
					print("[!] El cliente ha cerrado la conexion sin avisar (Menudo capullo) (O igual esta el puerto bloqueado, que es posible)")
	except KeyboardInterrupt: # "El excepto por defecto tiene que estar lo ultimo :nerd:"
		print("\rSaliendo...") # El carriage return para que no salga el ^C feo ese de pulsar CTRL-C
		exit()
	except Exception as ErrorProg:
		print(f"[!] Se ha producido un error critico... {ErrorProg}")
		exit()
