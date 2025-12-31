import socket
import os
import json
import pwd
from datetime import datetime
import shutil
import random


BASE_DIR="/jmail/"


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
		json.dump(datos, f, indent=4)

def procesar(bytes, cliente):
	decoded_data = json.loads(bytes.decode('utf-8'))
	mail_info = decoded_data.get("MAIL", {})
	destinatario = mail_info.get("PARA", "desconocido")
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






if __name__ == "__main__":
	print("Este es el script comun. No me ejecutes")
