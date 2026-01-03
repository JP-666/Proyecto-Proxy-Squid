#!/bin/python3
import socket
import os
import json
import random
import sys
import threading
sys.path.append('/usr/bin/')
import jmail_comun

def cargar_ips_denegadas():
	ips = []
	ruta = "/etc/jmail/jmail.conf"
	if os.path.exists(ruta):
		with open(ruta, "r") as f:
			for linea in f:
				if linea.startswith("bloquear-ip"):
					ip = linea.split()[1]
					ips.append(ip)
	return ips

IP_ESCUCHA = "0.0.0.0"
PUERTO = 42069
BASE_DIR = "/jmail/"
CIERRE = b"HASTALAVISTABABY"

def manejar_cliente(conn, addr):
	client_ip = addr[0]
	ips_den = cargar_ips_denegadas() # Por si cambia en disco, como no tenemos MILLONES de archivos por segundo, no importa.
	try:
		with conn:
			if client_ip in ips_den:
				conn.sendall("No puedes enviar mensajes a este servidor.\n".encode("UTF-8"))
				print(f"[!] Bloqueado intento de conexión desde: {client_ip}")
				return # Cerramos este hilo

			# Si no está bloqueado, procedemos
			conn.sendall("HABLALE A LA MANO\n\n".encode('utf-8'))
			raw_data = b""
			while True:
				data = conn.recv(4096)
				if not data:
					break
				raw_data += data
				if raw_data.strip().endswith(CIERRE):
					raw_data = raw_data.strip()[:-len(CIERRE)]
					break
			if not mensajeadios:
				mensajeadios = random.choice(["SAYONARA", "CONSIDERA ESTO UN DIVORCIO", "VOLVERE!"])

			conn.sendall(f"\n{mensajeadios} (Se ha cerrado la conexion)\n".encode('utf-8'))

	except Exception as e:
		print(f"[!] Error manejando al cliente {client_ip}: {e}")

# EL RESTO DEL CODIGO ANTIGUO
os.makedirs(BASE_DIR, exist_ok=True)

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server:
	server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
	server.bind((IP_ESCUCHA, PUERTO))
	server.listen(25) # Hasta 25 personas esperando en cola. Puedes cambiar esto si quieres.

	print(f"J-Mail (Sin SSL) activo en puerto {PUERTO}...")
	print("Presiona CTRL+C para detener el servidor.")

	try:
		while True:
			conn, addr = server.accept()
			hilo = threading.Thread(target=manejar_cliente, args=(conn, addr))
			hilo.setDaemon(True) # Si el servidor muere, los hilos mueren con él
			hilo.start()

	except KeyboardInterrupt:
		print("\rSaliendo... (¡Hasta la vista, Baby!)")
		sys.exit()
	except Exception as ErrorProg:
		print(f"[!] Error crítico en el núcleo: {ErrorProg}")
		sys.exit()
