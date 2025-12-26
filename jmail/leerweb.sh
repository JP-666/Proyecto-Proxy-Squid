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
else
    echo "ERROR: Accion no permitida"
    exit 1
fi
