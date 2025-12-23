#!/bin/bash

echo -n "Introduce la nueva contraseña de admin (no se mostrará): "
read -s ncont
echo ""

conthash=$(php -r "echo password_hash(\$argv[1], PASSWORD_BCRYPT);" -- "$ncont") # Ni puta idea, pero funciona, BASH es raro.

if [ -z "$conthash" ]
then
    echo "Error: No se pudo generar el hash. ¿Está PHP instalado?"
    exit 1
fi

mysql -D router -e "UPDATE datoslogin SET contrahash = '$conthash' WHERE usuario = 'admin';"

unset ncont
