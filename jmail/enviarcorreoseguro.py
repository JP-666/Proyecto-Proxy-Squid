#!/bin/python3
import socket
import ssl
import os
import json

# Me falta algo, creo, no me acuerdo.
# Vale me he acordado, base64 para los 'adjuntos' :D

context = ssl.create_default_context()
context.check_hostname = False
context.verify_mode = ssl.CERT_NONE
# Por que esta auto-firmado, pero vamos, que va a ser local, de todas formas.
# Esperemos que no haya ningun JP y se de cuenta que puede hackearlo haciendose pasar por la IP del servidor!
# Jaja, es broma, espero poder arreglar esto.



# Leyendo datos

IP = input("IP (127.0.0.1) > ") or "127.0.0.1"

if not os.path.isfile("jmail.json"):

	print("No se ha encontrado el archivo de jmail (jmail.json)... Componiendo uno")
	De = input(f"¿Quien envia el mail? ({os.environ['USER']}): ") or os.environ['USER'] # ESTO ES UN MILLON DE VECES MEJOR QUE BASH OH DIOS MIO
	Para = input(f"¿Para quien (Usuario)? (root): ") or "root"
	Asunto = input("¿Asunto? (Mensaje importante cifrado) ") or "Mensaje Importante Cifrado"
	Cuerpo = input("¿Cuerpo? (Hola!) " ) or "Hola!"

	print("Preparando mail...")
	MAIL = {
		"MAIL" : {
			"DE": De,
			"PARA": Para,
			"ASUNTO": Asunto,
			"CUERPO": Cuerpo
		}
	}
	print("Mail listo")
	mailjson=json.dumps(MAIL)
	mailjson+="\nHASTALAVISTABABY" # Cerramos el 'email'
	mailjson=mailjson.encode("UTF-8")

else:
	print("Usando el archivo jmail.json existente")
	try:
		mailjson = open("jmail.json", "r").read().encode("UTF-8")
	except:
		print("No se puede abrir el archivo!")
		exit



with socket.create_connection((IP, 42068)) as sock: # Nos conectamos
	with context.wrap_socket(sock, server_hostname=IP) as sseguro: # Elevamos a SSL
		sseguro.sendall(mailjson)
		print(sseguro.recv(1024).decode())



