#!/bin/bash
# Uso: leerweb.sh <usuario> <archivo_o_comando>

USUARIO=$1
ACCION=$2

# 1. Seguridad básica: No permitir salir de /jmail
if [[ -z "$USUARIO" ]]; then
    echo "ERROR: Usuario no especificado"
    exit 1
fi

# 2. Acciones permitidas
if [[ "$ACCION" == "LISTAR" ]]; then
    # Lista solo archivos .json en la carpeta del usuario
    ls -1 /jmail/"$USUARIO"/*.json 2>/dev/null
elif [[ "$ACCION" == "LEER" ]]; then
    # Lee un archivo específico (el tercer argumento)
    ARCHIVO=$(basename "$3")
    cat "/jmail/$USUARIO/$ARCHIVO"
elif [[ "$ACCION" == "BORRAR" ]]; then
    ARCHIVO=$(basename "$3")
    if [[ ! -d /jmail/$USUARIO/leidos ]]; then # Realmente no me gusta if [ ... ]; then, pero aqui es mas compacto y mas comodo con else-ifs.
        mkdir -p /jmail/$USUARIO/leidos
    fi
    mv /jmail/$USUARIO/$ARCHIVO /jmail/$USUARIO/leidos/
    echo "<h1>Ok, puedes cerrar esta pestaña</h1>"
else
    echo "ERROR: Accion no permitida"
    exit 1
fi
