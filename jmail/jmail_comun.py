import socket
import os
import json
import pwd
from datetime import datetime
import shutil
import random


BASE_DIR="/jmail/"


if os.path.exists("/etc/jmail/jmail.conf"):
	us_den = []
	with open("/etc/jmail/jmail.conf", "r") as f:
		for linea in f:
			if linea.startswith("bloquear-usuario"):
				usuario = linea.split()[1]
				us_den.append(usuario)
# Esto es lento, pero parece ser lo mas simple que se puede hacer



def easter_eggs(nombre):
# Unos "easter eggs", que no hay por que pasarlo mal!
	c = nombre.lower()
	print(f"Probando easter eggs: {c}")
	match c:
		case "neo":
			return "The Matrix Has You, Neo..."
		case "tu":
			return "No... Tu no puedes ser yo... Por que yo seria tu!"
		case "42":
			return "WOW. La respuesta para todo en el universo enviandome un mensaje, que emocion!"
		case _:
			print("No habia ningun easter egg para el nombre")

def bloqueado(usuario):
	if usuario in us_den:
		print(f"Email para usuario bloqueado {usuario} bloqueado")
		return True

def usuario_existe(nombre):
	try:
		pwd.getpwnam(nombre)
		return True
	except KeyError:
		print(f"Usuario {nombre} no existe")
		return False

def crear_ruta(quien):
	ruta_final=f"{BASE_DIR}/{quien}"
	try:
		os.makedirs(ruta_final)
		shutil.chown(ruta_final, user=quien, group=quien)
		os.chmod(ruta_final, 0o770)
	except FileExistsError:
		print(f"Ya tiene carpeta: {quien}")
	except Exception as errorruta:
		print(errorruta)

def tiempo():
	return datetime.now().strftime("%H:%M:%S_%d-%m-%Y")


def correoperdido(ip, datos):
	crear_ruta("perdido")
	archivo=f"/jmail/perdido/{ip}_{tiempo()}.invalido"
	with open(archivo, "w") as f:
		try:
			json.dump(datos, f, indent=4)
			print("Guardado JSON con errores como correo perdido")
		except:
			f.write(datos)
			print("Guardando datos (Sin formato json) como correo perdidio")

def procesar(datos, cliente):
	try:
		decoded_data = json.loads(datos.decode('utf-8'))
	except Exception as ErrorJson:
		correoperdido(cliente,datos.decode('utf-8'))
		return "[!] Tu mensaje se ha enviado a correo perdido"
		exit()

	mail_info = decoded_data.get("MAIL", {})
	destinatario = mail_info.get("PARA", "desconocido")
	if bloqueado(destinatario):
		return f"No puedes enviar correos a {destinatario}"
	huevo = easter_eggs(mail_info.get("DE"))
	if usuario_existe(destinatario):
		ruta_final = os.path.join(BASE_DIR, destinatario)
		crear_ruta(destinatario)
	else:
		correoperdido(cliente, decoded_data)
		return
	filename = os.path.join(ruta_final, f"{cliente}_{tiempo()}.json")
	with open(filename, "w") as f:
		json.dump(decoded_data, f, indent=4)
		print(f"[+] Mail de {cliente} para '{destinatario}' guardado.")
	return huevo





if __name__ == "__main__":
	print("Este es el script comun. No me ejecutes")
