import socket
import ssl
# Me falta algo, creo, no me acuerdo.
# Vale me he acordado, base64 para los 'adjuntos' :D

servidor = "localhost" # O, igual, pedir los datos.

mail = open("TEST.json").read().encode("UTF-8") # O pedir correo, por el stdin, no se.

context = ssl.create_default_context()
context.check_hostname = False
context.verify_mode = ssl.CERT_NONE
# Por que esta auto-firmado, pero vamos, que va a ser local, de todas formas.
# Esperemos que no haya ningun JP y se de cuenta que puede hackearlo haciendose pasar por la IP del servidor!
# Jaja, es broma, espero poder arreglar esto.

with socket.create_connection((servidor, 42068)) as sock: # Nos conectamos
	with context.wrap_socket(sock, server_hostname=servidor) as sseguro: # Elevamos a SSL
		sseguro.sendall(mail)
		print(sseguro.recv(1024).decode())



