#!/bin/python3
import socket
import os
import json
import pwd
from datetime import datetime
import shutil
import random # Esto lo tengo aqui para que seleccione de la lista de mensajes de "despedida"


IP_ESCUCHA = "0.0.0.0" # Todas las interfaces = 0.0.0.0, bloquear a una interfaz = (IP)
PUERTO = 42069 # Puedes cambiar esto, pero avisa a los clientes
BASE_DIR = "/jmail/" # JMAIL por que... Bueno, Gmail, pero J de Jua... Bueno, creo que lo pillas... ¿No?
CIERRE = b"HASTALAVISTABABY" # Esto es lo que cierra el "correo"


# Crear carpeta base, la puedes cambiar arriba, aunque no se por que querrias (¿?¿?)
os.makedirs(BASE_DIR, exist_ok=True)

def usuario_existe(nombre): # Miramos si el "PARA" es un usuario del sistema.
	try:
		pwd.getpwnam(nombre)
		return True
	except KeyError:
		return False

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
				try:
					# Parsear el JSON recibido y buscar el "PARA"
					decoded_data = json.loads(raw_data.decode('utf-8'))
					mail_info = decoded_data.get("MAIL", {})
					destinatario = mail_info.get("PARA", "desconocido")
					if usuario_existe(destinatario):
						ruta_final = os.path.join(BASE_DIR, destinatario)
					else:
						ruta_final = os.path.join(BASE_DIR, "perdido")
					os.makedirs(ruta_final, exist_ok=True)
					os.chmod(ruta_final, 0o770) # U+G LEX
					shutil.chown(ruta_final, user=destinatario, group=destinatario)
					# Nombre de archivo: (IP)_(TIEMPO).json
					# Actualizacion: Este "timestamp" es mas leible que (horaminutosegundo)
					# Ahora es (hora:minuto:segundo_dia_mes_añolargo)
					timestamp = datetime.now().strftime("%H:%M:%S_%d-%m-%Y")
					filename = os.path.join(ruta_final, f"{client_ip}_{timestamp}.json")
					with open(filename, "w") as f:
						json.dump(decoded_data, f, indent=4)
					print(f"[+] Mail de {client_ip} para '{destinatario}' guardado.")
				except Exception as e: # Si el JSON esta mal
					ruta_error = os.path.join(BASE_DIR, "perdido")
					os.makedirs(ruta_error, exist_ok=True)
					timestamp = datetime.now().strftime("%H%M%S")
					filename = os.path.join(ruta_error, f"{client_ip}_{timestamp}.invalido")
					with open(filename, "wb") as f:
						f.write(raw_data)
					print(f"[?] Datos malformados guardados en: {filename}") # Si no, lo metemos en la carpeta de "perdido"
				mensajeadios = random.choice(["SAYONARA", "CONSIDERA ESTO UN DIVORCIO", "VOLVERE!"])
				# Esto en Godot lo hubiera escrito tal que ("var mensajeadios = ["..."].pick_random()")
				# Pero claro solo se me ocurre a mi aprender programacion de videojuegos ANTES de
				# Aprender programacion de... Bueno, de verdad.
				try:
					conn.sendall(f"\n{mensajeadios} (Se ha cerrado la conexion)\n".encode('utf-8'))
				except: # Si cierra la puerta (conexion) en la cara. O si el puerto esta bloqueado.
					print("[!] El cliente ha cerrado la conexion sin avisar (Menudo capullo) (O igual esta el puerto bloqueado, que es posible)"]
	except KeyboardInterrupt:
		print("\nPreprando para salir...") # Aqui falta la logíca para cerrar el puerto, pero bueno, ya me pondre con eso despues de navidad. Que Cristóbal dijo que teniamos todo el curso.


# TO-DO(s):
# 	- Hacer cliente
#	- Implementarlo en la interfaz de configuracion.
#	- ???
#	- Nada, es perfecto.
#		- Bueno, perfecto no, pero mas usable que mail, pues como que es.
