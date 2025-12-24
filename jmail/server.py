#!/bin/python3
import socket
import os
import json
import pwd
from datetime import datetime

IP_ESCUCHA = "0.0.0.0" # Todas las interfaces = 0.0.0.0, bloquear a una interfaz = (IP)
PUERTO = 42069 # Puedes cambiar esto, pero avisa a los clientes
BASE_DIR = "/jmail/" # JMAIL por que... Bueno, Gmail, pero J de Jua... Bueno, creo que lo pillas... ¿No?

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
				raw_data = b""
				while True:
					data = conn.recv(4096)
					if not data:
						break
					raw_data += data
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
					# Nombre de archivo: (IP)_(TIEMPO).json
					timestamp = datetime.now().strftime("%H%M%S")
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
	except KeyboardInterrupt:
		print("\nPreprando para salir...") # Aqui falta la logíca para cerrar el puerto, pero bueno, ya me pondre con eso despues de navidad. Que Cristóbal dijo que teniamos todo el curso.


# TO-DO(s):
# 	- Hacer cliente
#	- Implementarlo en la interfaz de configuracion.
#	- ???
#	- Nada, es perfecto.
#		- Bueno, perfecto no, pero mas usable que mail, pues como que es.
