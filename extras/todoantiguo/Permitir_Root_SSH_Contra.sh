#!/bin/bash

# Esto nos permite iniciar sesion como superusuario en ssh con contraseña, por no tener que estar creando certificados ni nada.
# Esto es MUY inseguro, no deberias hacer esto en un servidor en producion

sed 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config | tee /etc/ssh/sshd_config
# "sed 's/string/nuevostring/' archivo" devuelve el contenido de archivo "archivo" con "string" reemplazo por "nuevostring".
# "tee /etc/ssh/sshd_config" hace que la salida del comando anterior a stdin se escriba en un archivo, esto es recomendable si se utiliza alguna herramienta de escalacion de privilegios como sudo, en este caso, al asumir que todo el script se esta ejecutando como root, no hace falta, pero aun asi, es una forma 'correcta' de hacerlo.

systemctl restart sshd
# Reiniciamos el servidor ssh
