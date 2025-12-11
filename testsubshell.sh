#!/bin/bash
# Comprueba que tenemos las funcionalidades que necesita el script de instalacion
export test="Pasado con exito, si estas viendo esto, la subshell ha ejecutado este comando y ha salido bien, si no es asi, asegurate de que tu shell soporta los argumentos heredados de otros scripts!"
echo
$SHELL -c 'echo $test; exit'
echo
echo "A continuacion se te soltara en la nueva shell, puedes salir con exit, o investigar el entorno"
echo
$SHELL -x
